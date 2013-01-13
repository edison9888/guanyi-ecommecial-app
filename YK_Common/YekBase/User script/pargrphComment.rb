#!/bin/sh

# 设置项
# Output下拉列表中选择Replace Selection

echo "%%%{PBXSelection}%%%"
echo "#pragma mark -"
echo "#pragma mark %%%{PBXSelectedText}%%%"
echo "%%%{PBXSelection}%%%"