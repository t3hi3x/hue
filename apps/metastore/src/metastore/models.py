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

from django.db import models

ILLEGAL_NAMES = ['SELECT', 'TABLE', 'COLUMN', 'CREATE', 'DROP', 'DATA', 'INSERT', 'LOAD', 'INPATH',
                  'PARTITION', 'INTO', 'OVERWRITE', 'DIRECTORY', 'LOCAL', 'IF', 'NOT', 'EXISTS', 'STRING',
                  'INT', 'FROM', 'ORDER', 'BY', 'GROUP', 'DESC', 'ASC', 'UNION', 'LIMIT', 'TABLESAMPLE',
                  'BUCKET', 'CLUSTERED', 'ON', 'OUT', 'PERCENT', 'TINYINT', 'SMALLINT', 'BIGINT', 'BOOLEAN',
                  'FLOAT', 'DOUBLE', 'BINARY', 'TIMESTAMP', 'ARRAY', 'MAP', 'STRUCT', 'UNIONTYPE', 'LATERAL',
                  'VIEW', 'AS', 'FUNCTION', 'EXPLAIN', 'DISTRIBUTE', 'CLUSTERED', 'EXPLAIN', 'DESCRIBE',
                  'OR', 'AND', 'SORT']

class Relationship(models.Model):
  name = models.CharField(max_length=255)
  description = models.TextField(null=True, blank=True)
  JOIN_TYPES = [('iner', 'INNER JOIN')] #, ('left', 'LEFT OUTER JOIN'), ('rght', 'RIGHT OUTER JOIN'), ('full', 'FULL OUTER JOIN'), ('lsem', 'LEFT SEMI JOIN')]
  JOIN_OPERATORS = [('equl', '='), ('nteq', '<>'), ('lstn', '<'), ('gttn', '>')]
  table1 = models.CharField(max_length=767)
  field1 = models.CharField(max_length=767)
  table2 = models.CharField(max_length=767)
  field2 = models.CharField(max_length=767)
  join = models.CharField(max_length=4, choices=JOIN_TYPES)
  operation = models.CharField(max_length=4, choices=JOIN_OPERATORS)

  def __unicode__(self):
    return self.name

  def sql(self):
    return '%s %s ON (%s.%s %s %s.%s)' % (self.get_join_display(), self.table1, self.table1, self.field1,
                                          self.get_operation_display(), self.table2, self.field2)