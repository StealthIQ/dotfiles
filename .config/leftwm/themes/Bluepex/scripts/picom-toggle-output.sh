#!/usr/bin/sh

green=#02fc34
red=#fc0202

#if pgrep -x "picom" > /dev/null
#then
#  echo %{u"$green"}%{T4}%{F"$green"}
#else
#  echo %{u"$red"}%{T4}%{F"$red"}
#fi

if pgrep -x "picom" > /dev/null
then
 echo %{F"$green"}
else
 echo %{F"$red"}
fi

# if pgrep -x "picom" > /dev/null
# then
#   echo %{u"$green"}%{T4}%{F"$green"}蘒
# else
#   echo %{u"$red"}%{T4}%{F"$red"}﨡
# fi
