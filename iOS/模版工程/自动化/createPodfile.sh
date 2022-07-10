
CONTENT="
platform :ios, '9.0'\n
use_frameworks!\n
target '$1' do\n
\tpod 'YYText'\n
end\n
"
echo  $CONTENT > ./$1/Podfile