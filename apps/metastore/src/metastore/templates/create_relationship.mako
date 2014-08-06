## Licensed to Cloudera, Inc. under one
## or more contributor license agreements.  See the NOTICE file
## distributed with this work for additional information
## regarding copyright ownership.  Cloudera, Inc. licenses this file
## to you under the Apache License, Version 2.0 (the
## "License"); you may not use this file except in compliance
## with the License.  You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
<%!
from desktop.views import commonheader, commonfooter
from django.utils.translation import ugettext as _
%>

<%namespace name="components" file="components.mako" />
<%namespace name="actionbar" file="actionbar.mako" />

${ commonheader(_("Create Relationship"), 'metastore', user) | n,unicode }
${ components.menubar() }

<div class="container-fluid">
  <div class="row-fluid">
    <div class="span3">
        <div class="sidebar-nav">
            <ul class="nav nav-list">
                <li class="nav-header">${_('Actions')}</li>
                <li><a href="${ url(app_name + ':create_relationship')}">${_('Create a new relationship')}</a></li>
            </ul>
        </div>
    </div>

    <div class="span9">
      <div class="card" style="margin-top: 0">
        <h1 class="card-heading simple">${_('Create a new relationship')}</h1>
        <div class="card-body">
          <p>

      <ul id="step-nav" class="nav nav-pills">
          <li class="active"><a href="#step/1" class="step">${_('Step 1: Name')}</a></li>
          <li><a href="#step/2" class="step">${_('Step 2: Location')}</a></li>
      </ul>

      <form action="${ url(app_name + ':create_relationship')}" method="POST" id="mainForm" class="form-horizontal">
        <div class="steps">
          <div id="step1" class="stepDetails">
              <fieldset>
                  <div class="alert alert-info"><h3>${_('Create a relationship')}</h3>${_("Let's start with a name and description.")}</div>
                  <div class="control-group">
                      ${components.bootstrapLabel(relationship_form['name'])}
                      <div class="controls">
                          ${components.field(relationship_form["name"], attrs=dict(
                            placeholder=_('Relationship Name'),
                          )
                          )}
                          <span  class="help-inline error-inline hide">${_('This field is required. Spaces are not allowed.')}</span>
                          <p class="help-block">
                              ${_('Name of the new relationship.')}
                          </p>
                      </div>
                  </div>
                  ${components.bootstrapLabel(relationship_form['comment'])}
                  <div class="control-group">
                      <div class="controls">
                          ${components.field(relationship_form["comment"], attrs=dict(
                            placeholder=_('Description'),
                          )
                          )}
                          <p class="help-block">
                              ${_("Describe the new relationship.")}
                          </p>
                      </div>
                  </div>
              </fieldset>
          </div>

          <div id="step2" class="stepDetails hide">
            <fieldset>
                  <div class="alert alert-info"><h3>${_('Define relationship')}</h3>${_("Finally, let's define which fields to create a relationship for.")}</div>
                  <div class="control-group">
                      ${components.bootstrapLabel(relationship_form['database1'])}
                      <div class="controls">
                          ${components.field(relationship_form["database1"], attrs=dict(
                            placeholder=_('Left Database'),
                          )
                          )}
                          <span  class="help-inline error-inline hide">${_('This field is required. Spaces are not allowed.')}</span>
                          <p class="help-block">
                              ${_('Database on the left-hand side of the Join')}
                          </p>
                      </div>
                  </div>
                  <div class="control-group">
                      ${components.bootstrapLabel(relationship_form['table1'])}
                      <div class="controls">
                          ${components.field(relationship_form["table1"], attrs=dict(
                            placeholder=_('Left Table'),
                          )
                          )}
                          <span  class="help-inline error-inline hide">${_('This field is required. Spaces are not allowed.')}</span>
                          <p class="help-block">
                              ${_('Table on the left-hand side of the Join')}
                          </p>
                      </div>
                  </div>
                  <div class="control-group">
                      ${components.bootstrapLabel(relationship_form['field1'])}
                      <div class="controls">
                          ${components.field(relationship_form["field1"], attrs=dict(
                            placeholder=_('Left Field'),
                          )
                          )}
                          <span  class="help-inline error-inline hide">${_('This field is required. Spaces are not allowed.')}</span>
                          <p class="help-block">
                              ${_('Field on the left-hand side of the Join')}
                          </p>
                      </div>
                  </div>
                  <div class="control-group">
                      ${components.bootstrapLabel(relationship_form['join'])}
                      <div class="controls">
                          <label class="radio">
                            <input type="radio" name="join" value="INNER JOIN"
                                % if selected == "INNER JOIN":
                                   checked
                                % endif
                                    >
                            ${_('INNER JOIN')}
                            <span  class="help-inline error-inline hide">${_('This field is required. Spaces are not allowed.')}</span>
                            <span class="help-inline">
                            ${_('(Requires values in both tables for a match.)')}
                            </span>
                        </label>
                      </div>
                  </div>
                  <div class="control-group">
                      ${components.bootstrapLabel(relationship_form['join'])}
                      <div class="controls">
                          <label class="radio">
                            <input type="radio" name="Operation" value="="
                                % if selected == "=":
                                   checked
                                % endif
                                    >
                            ${_('=')}
                            <span class="help-inline">
                            ${_('(Fields are equal in left and right tables.)')}
                            </span>
                        </label>
                      </div>
                  </div>
                  <div class="control-group">
                      ${components.bootstrapLabel(relationship_form['database2'])}
                      <div class="controls">
                          ${components.field(relationship_form["database2"], attrs=dict(
                            placeholder=_('Right Database'),
                          )
                          )}
                          <span  class="help-inline error-inline hide">${_('This field is required. Spaces are not allowed.')}</span>
                          <p class="help-block">
                              ${_('Database on the right-hand side of the Join')}
                          </p>
                      </div>
                  </div>
                  <div class="control-group">
                      ${components.bootstrapLabel(relationship_form['table2'])}
                      <div class="controls">
                          ${components.field(relationship_form["table2"], attrs=dict(
                            placeholder=_('Right Table'),
                          )
                          )}
                          <span  class="help-inline error-inline hide">${_('This field is required. Spaces are not allowed.')}</span>
                          <p class="help-block">
                              ${_('Table on the right-hand side of the Join')}
                          </p>
                      </div>
                  </div>
                  <div class="control-group">
                      ${components.bootstrapLabel(relationship_form['field2'])}
                      <div class="controls">
                          ${components.field(relationship_form["field2"], attrs=dict(
                            placeholder=_('Right Field'),
                          )
                          )}
                          <span  class="help-inline error-inline hide">${_('This field is required. Spaces are not allowed.')}</span>
                          <p class="help-block">
                              ${_('Field on the left-hand side of the Join')}
                          </p>
                      </div>
                  </div>
              </fieldset>
        </div>
        </div>
        <div class="form-actions" style="padding-left: 10px">
            <button type="button" id="backBtn" class="btn hide">${_('Back')}</button>
            <button type="button" id="nextBtn" class="btn btn-primary">${_('Next')}</button>
            <input id="submit" type="submit" name="create" class="btn btn-primary hide" value="${_('Create relationship')}" />
        </div>
      </form>
      </p>
      </div>
    </div>
    </div>
  </div>
</div>


<div id="chooseFile" class="modal hide fade">
    <div class="modal-header">
        <a href="#" class="close" data-dismiss="modal">&times;</a>
        <h3>${_('Choose a file')}</h3>
    </div>
    <div class="modal-body">
        <div id="filechooser">
        </div>
    </div>
    <div class="modal-footer">
    </div>
</div>

<style type="text/css">
  #filechooser {
    min-height: 100px;
    overflow-y: auto;
    margin-top: 10px;
    height: 250px;
  }

  .inputs-list {
    list-style: none outside none;
    margin-left: 0;
  }

  .remove {
    float: right;
  }

  .error-inline {
    color: #B94A48;
    font-weight: bold;
  }

  .steps {
    min-height: 350px;
    margin-top: 10px;
  }

  div .alert {
    margin-bottom: 30px;
  }
</style>

</div>


<script src="/static/ext/js/routie-0.3.0.min.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript" charset="utf-8">
$(document).ready(function () {
  // Routing
  var step = 1;
  routie({
    'step/1': function(node_type) {
      $("#step-nav").children().removeClass("active");
      $("#step-nav").children(":nth-child(1)").addClass("active");
      $('.stepDetails').hide();
      $('#step1').show();
      $("#backBtn").hide();
      $("#nextBtn").show();
      $("#submit").hide();
    },
    'step/2': function(node_type) {
      $("#step-nav").children().removeClass("active");
      $("#step-nav").children(":nth-child(2)").addClass("active");
      $('.stepDetails').hide();
      $('#step2').show();
      $("#backBtn").show();
      $("#nextBtn").hide();
      $("#submit").show();
    }
  });
  routie('step/' + step);

  // events
  $(".fileChooserBtn").click(function (e) {
    e.preventDefault();
    var _destination = $(this).attr("data-filechooser-destination");
    $("#filechooser").jHueFileChooser({
      initialPath: $("input[name='" + _destination + "']").val(),
      onFolderChoose: function (filePath) {
        $("input[name='" + _destination + "']").val(filePath);
        $("#chooseFile").modal("hide");
      },
      createFolder: false,
      selectFolder: true,
      uploadFile: false
    });
    $("#chooseFile").modal("show");
  });

  $("#id_use_default_location").change(function () {
    if (!$(this).is(":checked")) {
      $("#location").slideDown();
    }
    else {
      $("#location").slideUp();
    }
  });

  $("#submit").click(function() {
    return validate();
  });

  $("#nextBtn").click(function () {
      if (validate()) {
      routie('step/' + ++step);
    }
  });

  $("#backBtn").click(function () {
    // To get to the current step
    // users will have to get through all previous steps.
    routie('step/' + --step);
  });

  $(".step").click(function() {
    return validate();
  });

  // Validation
  function validate() {
    switch(step) {
      case 1:
        var relationshipNameFld = $("input[name='relationship-name']");
        if (!isValid($.trim(relationshipNameFld.val()))) {
          showFieldError(relationshipNameFld);
          return false;
        } else {
          hideFieldError(relationshipNameFld);
        }
      break;

      case 2:
        var relationshipDatabase1Fld = $("input[name='relationship-database1']");
        var case_2_valid=true;

        if (!isValid($.trim(relationshipDatabase1Fld.val()))) {
          showFieldError(relationshipDatabase1Fld);
          case_2_valid = false;
        } else {
          hideFieldError(relationshipDatabase1Fld);
        }
        var relationshipTable1Fld = $("input[name='relationship-table1']");
        if (!isValid($.trim(relationshipTable1Fld.val()))) {
          showFieldError(relationshipTable1Fld);
          case_2_valid = false;
        } else {
          hideFieldError(relationshipTable1Fld);
        }
        var relationshipField1Fld = $("input[name='relationship-field1']");
        if (!isValid($.trim(relationshipField1Fld.val()))) {
          showFieldError(relationshipField1Fld);
          case_2_valid = false;
        } else {
          hideFieldError(relationshipField1Fld);
        }
        var relationshipDatabase2Fld = $("input[name='relationship-database2']");
        if (!isValid($.trim(relationshipDatabase2Fld.val()))) {
          showFieldError(relationshipDatabase2Fld);
          case_2_valid = false;
        } else {
          hideFieldError(relationshipDatabase2Fld);
        }
        var relationshipTable2Fld = $("input[name='relationship-table2']");
        if (!isValid($.trim(relationshipTable2Fld.val()))) {
          showFieldError(relationshipTable2Fld);
          case_2_valid = false;
        } else {
          hideFieldError(relationshipTable1Fld);
        }
        var relationshipField2Fld = $("input[name='relationship-field2']");
        if (!isValid($.trim(relationshipField2Fld.val()))) {
          showFieldError(relationshipField2Fld);
          case_2_valid = false;
        } else {
          hideFieldError(relationshipField2Fld);
        }
        if (!case_2_valid) {
            return false;
        }
        var relationshipJoinFld = $("input[name='relationship-join']");
        if (!relationshipJoinFld.val()) {
          showFieldError(relationshipJoinFld);
          case_2_valid = false;
        } else {
          hideFieldError(relationshipJoinFld);
        }
        if (!case_2_valid) {
            return false;
        }
      break;
    }

    return true;
  }

  function isValid(str) {
    return (str != "" && str.indexOf(" ") == -1);
  }

  function showFieldError(field) {
    field.nextAll(".error-inline").not(".error-inline-bis").removeClass("hide");
  }

  function hideFieldError(field) {
    if (!(field.nextAll(".error-inline").hasClass("hide"))) {
      field.nextAll(".error-inline").addClass("hide");
    }
  }
});
</script>

${ commonfooter(messages) | n,unicode }
