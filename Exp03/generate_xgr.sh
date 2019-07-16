#!/bin/bash
for file in `ls conn_*tr`
  do
    awk -f cong.awk $file >xgr.$file
  done

