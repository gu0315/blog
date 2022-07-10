#参考 https://www.cnblogs.com/hello-LJ/p/4515641.html
require 'xcodeproj'
require 'fileutils'
require 'digest'

DIR = File.dirname(__FILE__)
NAME = ARGV.at(0);
BUNDLEID = ARGV.at(1);

def createProj()
    FileUtils.mkdir_p("#{NAME}");
    # 创建Example.xcodeproj工程文件，并保存
    Xcodeproj::Project.new("./#{NAME}/#{NAME}.xcodeproj").save
    # 打开创建的Example.xcodeproj文件
    proj = Xcodeproj::Project.open("./#{NAME}/#{NAME}.xcodeproj")
    # 创建一个分组，名称为Example，对应的路径为./Example
    group = proj.main_group.new_group("#{NAME}", "./#{NAME}")
    # 文件
    filesInTarget = Array[
        "AppDelegate.swift",
        "SceneDelegate.swift",
        "ViewController.swift",
        "Base.lproj/LaunchScreen.storyboard",
        "Base.lproj/Main.storyboard",
        "Assets.xcassets"
    ];
    # 创建target，主要的参数 type: application :dynamic_library framework :static_library 意思大家都懂的
    target = proj.new_target(:application, "#{NAME}", :ios)
    target.product_name = "#{NAME}"
    sourceFiles = Array.new
    # 将bundle加入到copy resources中
    for fr in filesInTarget.map { |f| group.new_reference(f) } do
        #.bundle文件需要加入到 Build Phases - Copy Resource Bundle中
        #.h文件需要加入到 Build Phase - Headers中
        if fr.path.include?(".bundle") || fr.path.include?(".storyboard") || fr.path.include?(".xcassets") then
            if not target.resources_build_phase.include?(fr) then
                build_file = proj.new(Xcodeproj::Project::Object::PBXBuildFile)
                build_file.file_ref = fr
                target.resources_build_phase.files << build_file
            end
        elsif fr.path.include?(".h") then
            headerPhase = target.headers_build_phase
            unless build_file = headerPhase.build_file(fr)
                build_file = proj.new(Xcodeproj::Project::Object::PBXBuildFile)
                build_file.file_ref = fr
                build_file.settings = { 'ATTRIBUTES' => ['Public'] }
                headerPhase.files << build_file
            end
        else
            sourceFiles << fr
        end
    end
    group.new_reference("Info.plist");
    # target添加相关的文件引用，这样编译的时候才能引用到
    target.add_file_references(sourceFiles)
    # 添加target配置信息
    target.build_configuration_list.set_setting('INFOPLIST_FILE', "$(SRCROOT)/#{NAME}/Info.plist")
    target.build_configuration_list.set_setting("VALID_ARCHS", "$(ARCHS_STANDARD)");
    target.build_configuration_list.set_setting("SWIFT_VERSION", "5.0");
    target.build_configuration_list.set_setting("MARKETING_VERSION", "1.0");
    target.build_configuration_list.set_setting("PRODUCT_BUNDLE_IDENTIFIER", "#{BUNDLEID}");
    # 保存
    proj.save
end

#脚本入口
def execute
    # createModuleLib
    createProj
end
execute