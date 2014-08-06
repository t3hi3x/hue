# encoding: utf-8
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models

class Migration(SchemaMigration):

    def forwards(self, orm):

        # Adding model 'Relationship'
        db.create_table('metastore_relationship', (
            ('name', self.gf('django.db.models.fields.CharField')(max_length=255)),
            ('description', self.gf('django.db.models.fields.TextField')(null=True, blank=True)),
            ('table1', self.gf('django.db.models.fields.CharField')(max_length=767)),
            ('table2', self.gf('django.db.models.fields.CharField')(max_length=767)),
            ('field1', self.gf('django.db.models.fields.CharField')(max_length=767)),
            ('field2', self.gf('django.db.models.fields.CharField')(max_length=767)),
            ('join', self.gf('django.db.models.fields.CharField')(max_length=4)),
            ('operation', self.gf('django.db.models.fields.CharField')(max_length=4)),
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
        ))
        db.send_create_signal('metastore', ['Relationship'])


    def backwards(self, orm):

        # Deleting model 'Document'
        db.delete_table('metastore_relationship')


    models = {
        'metastore_relationship': {
            'Meta': {'object_name': 'Relationship'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'description': ('django.db.models.fields.CharField', [], {'null': 'True', 'blank': 'True'}),
            'table1': ('django.db.models.fields.CharField', [], {'max_length': '767'}),
            'table2': ('django.db.models.fields.CharField', [], {'max_length': '767'}),
            'field1': ('django.db.models.fields.CharField', [], {'max_length': '767'}),
            'field2': ('django.db.models.fields.CharField', [], {'max_length': '767'}),
            'join': ('django.db.models.fields.CharField', [], {'max_length': '4'}),
            'operation': ('django.db.models.fields.CharField', [], {'max_length': '4'}),
        }
    }

    complete_apps = ['metastore']
