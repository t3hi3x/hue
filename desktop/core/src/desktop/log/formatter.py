import logging
import os

from pytz import timezone, datetime


class Formatter(logging.Formatter):
  def formatTime(self, record, datefmt=None):
    try:
      tz = timezone(os.environ['TZ'])
      ct = datetime.datetime.fromtimestamp(record.created, tz=tz)
    except:
      ct = datetime.datetime.fromtimestamp(record.created)

    if datefmt:
      s = ct.strftime(datefmt)
    else:
      t = ct.strftime("%Y-%m-%d %H:%M:%S")
      s = "%s,%03d" % (t, record.msecs)
    return s
