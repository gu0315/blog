#检查参数
# 项目名称
NAME="Test22"
# bundle identifier
BUNDLEID="com.guqianxiang.template.Template"

if [ -z "$NAME" ]; then
    echo "[E][-n=工程名]不能为空"
    exit
fi
if [ -z "$BUNDLEID" ]; then
    echo "[E][-b=bundleid]不能为空"
    exit
fi

# 检查本地模块是否存在
if [ -d ./$NAME ]; then
    echo "[E]本地已经有了名为 $NAME 的模块，请换个名字再试试"
    exit
fi

echo "[I]准备创建.xcodeproj文件..."
ruby createProj.rb $NAME $BUNDLEID
cp -r ./Template/Template ./${NAME}
# 修文件名类名
mv ./${NAME}/Template ./${NAME}/${NAME}

# 生成Podfile文件
echo "[I] 开始创建PodSpec文件..."
chmod 755 createPodfile.sh
createPodfile.sh ${NAME}
echo "[I] /Podfile 创建完成"

# 更新pod依赖 执行pod install
echo "[C] -> pod install"
cd ./${NAME}
pod install
