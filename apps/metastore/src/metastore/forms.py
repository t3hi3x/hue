#!/usr/bin/env python
# Licensed to Cloudera, Inc. under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  Cloudera, Inc. licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from django import forms
from django.utils.translation import ugettext as _, ugettext_lazy as _t

from desktop.lib.django_forms import simple_formset_factory, DependencyAwareForm
from desktop.lib.django_forms import ChoiceOrOtherField, MultiForm, SubmitButton
from filebrowser.forms import PathField

from beeswax import common
from beeswax.server.dbms import NoSuchObjectException
from beeswax.models import SavedQuery


class DbForm(forms.Form):
  """For 'show tables'"""
  database = forms.ChoiceField(required=False,
                           label='',
                           choices=(('default', 'default'),),
                           initial=0,
                           widget=forms.widgets.Select(attrs={'class': 'input-medium'}))

  def __init__(self, *args, **kwargs):
    databases = kwargs.pop('databases')
    super(DbForm, self).__init__(*args, **kwargs)
    self.fields['database'].choices = ((db, db) for db in databases)


class LoadDataForm(forms.Form):
  """Form used for loading data into an existing table."""
  path = PathField(label=_t("Path"))
  overwrite = forms.BooleanField(required=False, initial=False, label=_t("Overwrite?"))

  def __init__(self, table_obj, *args, **kwargs):
    """
    @param table_obj is a hive_metastore.thrift Table object,
    used to add fields corresponding to partition keys.
    """
    super(LoadDataForm, self).__init__(*args, **kwargs)
    self.partition_columns = dict()
    for i, column in enumerate(table_obj.partition_keys):
      # We give these numeric names because column names
      # may be unpleasantly arbitrary.
      name = "partition_%d" % i
      char_field = forms.CharField(required=True, label=_t("%(column_name)s (partition key with type %(column_type)s)") % {'column_name': column.name, 'column_type': column.type})
      self.fields[name] = char_field
      self.partition_columns[name] = column.name

"""
Relationship Forms
"""

def _clean_relationship(name):
  try:
    if False:
      raise forms.ValidationError(_('Table "%(name)s" already exists.') % {'name': name})
  except Exception:
    return name

class CreateRelationshipForm(DependencyAwareForm):
  """
  Form used in the create relationship page
  """
  dependencies = []

  # Basic Data
  name = common.HiveIdentifierField(label=_t("Relationship Name"), required=True)
  comment = forms.CharField(label=_t("Description"), required=False)

  database1 = forms.CharField(label=_t("Left Database"), required=True)
  table1 = forms.CharField(label=_t("Left Table"), required=True)
  field1 = forms.CharField(label=_t("Left Field"), required=True)

  join = forms.ChoiceField(label=_t("Join Type"), required=True, choices=common.to_choices(["INNER JOIN"]))
  operation = forms.ChoiceField(label=_t("Join Operation"), required=True, choices=common.to_choices(["="]))

  database2 = forms.CharField(label=_t("Right Database"), required=True)
  table2 = forms.CharField(label=_t("Right Table"), required=True)
  field2 = forms.CharField(label=_t("Right Field"), required=True)

  # Row Formatting
  #row_format = forms.ChoiceField(required=True,
  #                              choices=common.to_choices([ "Delimited", "SerDe" ]),
  #                              initial="Delimited")

  # Delimited Row
  # These initials are per LazySimpleSerDe.DefaultSeparators
  #field_terminator = ChoiceOrOtherField(label=_t("Field terminator"), required=False, initial=TERMINATOR_CHOICES[0][0],
  #  choices=TERMINATOR_CHOICES)
  #collection_terminator = ChoiceOrOtherField(label=_t("Collection terminator"), required=False, initial=TERMINATOR_CHOICES[1][0],
  #  choices=TERMINATOR_CHOICES)
  #map_key_terminator = ChoiceOrOtherField(label=_t("Map key terminator"), required=False, initial=TERMINATOR_CHOICES[2][0],
  #  choices=TERMINATOR_CHOICES)
  #dependencies += [
  #  ("row_format", "Delimited", "field_terminator"),
  #  ("row_format", "Delimited", "collection_terminator"),
  #  ("row_format", "Delimited", "map_key_terminator"),
  #]

  # Serde Row
  #serde_name = forms.CharField(required=False, label=_t("SerDe Name"))
  #serde_properties = forms.CharField(
  #                      required=False,
  #                      help_text=_t("Comma-separated list of key-value pairs. E.g. 'p1=v1, p2=v2'"))

  #dependencies += [
  #  ("row_format", "SerDe", "serde_name"),
  #  ("row_format", "SerDe", "serde_properties"),
  #]

  # File Format
  #file_format = forms.ChoiceField(required=False, initial="TextFile",
  #                      choices=common.to_choices(["TextFile", "SequenceFile", "InputFormat"]),
  #                      widget=forms.RadioSelect)
  #input_format_class = forms.CharField(required=False, label=_t("InputFormat Class"))
  #output_format_class = forms.CharField(required=False, label=_t("OutputFormat Class"))

  #dependencies += [
  #  ("file_format", "InputFormat", "input_format_class"),
  #  ("file_format", "InputFormat", "output_format_class"),
  #]

  # External?
  #use_default_location = forms.BooleanField(required=False, initial=True, label=_t("Use default location."))
  #external_location = forms.CharField(required=False, help_text=_t("Path to HDFS directory or file of table data."))

  #dependencies += [
  #  ("use_default_location", False, "external_location")
  #]

  def clean_name(self):
    return _clean_relationship(self.cleaned_data['name'])