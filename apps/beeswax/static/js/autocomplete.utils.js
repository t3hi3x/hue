// Licensed to Cloudera, Inc. under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  Cloudera, Inc. licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

function hac_jsoncalls(options) {
  if (typeof HIVE_AUTOCOMPLETE_BASE_URL != "undefined") {
    if (options.database == null) {
      $.getJSON(HIVE_AUTOCOMPLETE_BASE_URL, options.onDataReceived);
    }
    if (options.database != null) {
      if (options.table != null) {
        $.getJSON(HIVE_AUTOCOMPLETE_BASE_URL + options.database + "/" + options.table, options.onDataReceived);
      }
      else {
        $.getJSON(HIVE_AUTOCOMPLETE_BASE_URL + options.database + "/", options.onDataReceived);
      }
    }
  }
  else {
    try {
      console.error("You need to specify a HIVE_AUTOCOMPLETE_BASE_URL to use the autocomplete")
    }
    catch (e) {
    }
  }
}

function hac_hasExpired(timestamp){
  var TIME_TO_LIVE_IN_MILLIS = 600000; // 10 minutes
  return (new Date()).getTime() - timestamp > TIME_TO_LIVE_IN_MILLIS;
}

function hac_getTableAliases(textScanned) {
  var _aliases = {};
  var _val = textScanned.split("\n").join(" ");
  var _from = _val.toUpperCase().indexOf("FROM ");
  if (_from > -1) {
    var _match = _val.toUpperCase().substring(_from).match(/ ON| LIMIT| WHERE| GROUP| SORT| ORDER BY|;/);
    var _to = _val.length;
    if (_match) {
      _to = _match.index;
    }
    var _found = _val.substr(_from, _to).replace(/(\r\n|\n|\r)/gm, "").replace(/from/gi, "").replace(/join/gi, ",").split(",");
    for (var i = 0; i < _found.length; i++) {
      var _tablealias = $.trim(_found[i]).split(" ");
      if (_tablealias.length > 1) {
        _aliases[_tablealias[1]] = _tablealias[0];
      }
    }
  }
  return _aliases;
}

function hac_getTableColumns(databaseName, tableName, textScanned, callback) {
  if (tableName.indexOf("(") > -1) {
    tableName = tableName.substr(tableName.indexOf("(") + 1);
  }

  var _aliases = hac_getTableAliases(textScanned);
  if (_aliases[tableName]) {
    tableName = _aliases[tableName];
  }

  if ($.totalStorage('columns_' + databaseName + '_' + tableName) != null && $.totalStorage('extended_columns_' + databaseName + '_' + tableName) != null) {
    callback($.totalStorage('columns_' + databaseName + '_' + tableName), $.totalStorage('extended_columns_' + databaseName + '_' + tableName));
    if ($.totalStorage('timestamp_columns_' + databaseName + '_' + tableName) == null || hac_hasExpired($.totalStorage('timestamp_columns_' + databaseName + '_' + tableName))){
      hac_jsoncalls({
        database: databaseName,
        table: tableName,
        onDataReceived: function (data) {
          if (typeof HIVE_AUTOCOMPLETE_GLOBAL_CALLBACK == "function") {
            HIVE_AUTOCOMPLETE_GLOBAL_CALLBACK(data);
          }
          if (data.error) {
            hac_errorHandler(data);
          }
          else {
            $.totalStorage('columns_' + databaseName + '_' + tableName, (data.columns ? "* " + data.columns.join(" ") : "*"));
            $.totalStorage('extended_columns_' + databaseName + '_' + tableName, (data.extended_columns ? data.extended_columns : []));
            $.totalStorage('timestamp_columns_' + databaseName + '_' + tableName, (new Date()).getTime());
          }
        }
      });
    }
  }
  else {
    hac_jsoncalls({
      database: databaseName,
      table: tableName,
      onDataReceived: function (data) {
        if (typeof HIVE_AUTOCOMPLETE_GLOBAL_CALLBACK == "function") {
          HIVE_AUTOCOMPLETE_GLOBAL_CALLBACK(data);
        }
        if (data.error) {
          hac_errorHandler(data);
        }
        else {
          $.totalStorage('columns_' + databaseName + '_' + tableName, (data.columns ? "* " + data.columns.join(" ") : "*"));
          $.totalStorage('extended_columns_' + databaseName + '_' + tableName, (data.extended_columns ? data.extended_columns : []));
          $.totalStorage('timestamp_columns_' + databaseName + '_' + tableName, (new Date()).getTime());
          callback($.totalStorage('columns_' + databaseName + '_' + tableName), $.totalStorage('extended_columns_' + databaseName + '_' + tableName));
        }
      }
    });
  }
}

function hac_tableHasAlias(tableName, textScanned) {
  var _aliases = hac_getTableAliases(textScanned);
  for (var alias in _aliases) {
    if (_aliases[alias] == tableName) {
      return true;
    }
  }
  return false;
}

function hac_getTables(databaseName, callback) {
  if ($.totalStorage('tables_' + databaseName) != null) {
    callback($.totalStorage('tables_' + databaseName));
    if ($.totalStorage('timestamp_tables_' + databaseName) == null || hac_hasExpired($.totalStorage('timestamp_tables_' + databaseName))){
      hac_jsoncalls({
        database: databaseName,
        onDataReceived: function (data) {
          if (typeof HIVE_AUTOCOMPLETE_GLOBAL_CALLBACK == "function") {
            HIVE_AUTOCOMPLETE_GLOBAL_CALLBACK(data);
          }
          if (data.error) {
            hac_errorHandler(data);
          }
          else {
            $.totalStorage('tables_' + databaseName, data.tables.join(" "));
            $.totalStorage('timestamp_tables_' + databaseName, (new Date()).getTime());
          }
        }
      });
    }
  }
  else {
    hac_jsoncalls({
      database: databaseName,
      onDataReceived: function (data) {
        if (typeof HIVE_AUTOCOMPLETE_GLOBAL_CALLBACK == "function") {
          HIVE_AUTOCOMPLETE_GLOBAL_CALLBACK(data);
        }
        if (data.error) {
          hac_errorHandler(data);
        }
        else {
          if (data.tables) {
            $.totalStorage('tables_' + databaseName, data.tables.join(" "));
            $.totalStorage('timestamp_tables_' + databaseName, (new Date()).getTime());
            callback($.totalStorage('tables_' + databaseName));
          }
        }
      }
    });
  }
}

function hac_errorHandler(data) {
  $(document).trigger('error.autocomplete');
  if (typeof HIVE_AUTOCOMPLETE_FAILS_SILENTLY_ON == "undefined" || data.code == null || HIVE_AUTOCOMPLETE_FAILS_SILENTLY_ON.indexOf(data.code) == -1){
    if (typeof HIVE_AUTOCOMPLETE_FAILS_QUIETLY_ON != "undefined" && HIVE_AUTOCOMPLETE_FAILS_QUIETLY_ON.indexOf(data.code) > -1){
      $(document).trigger('info', data.error);
    }
    else {
      $(document).trigger('error', data.error);
    }
  }
}