Pod::Spec.new do |s|

  #库名，和文件名一样
  s.name         = "TABCardView"

  #tag方式：填tag名称
  #commit方式：填commit的id
  s.version      = "0.0.2"

  #库的简介
  s.summary      = "TABCardView是一个iOS平台上的卡片视图的封装"

  #库的描述
  s.description  = <<-DESC
  TABCardView是一个iOS平台上的卡片视图的封装
                           DESC
  #库的远程仓库地址
  s.homepage     = "https://github.com/tigerAndBull/TABCardView"

  #版权方式
  s.license = { :type => "MIT", :file => "LICENSE" }

  #库的作者
  s.author             = { "tigerAndBull" => "1429299849@qq.com" }

  #依赖于ios平台上的8.0
  s.platform     = :ios, "8.0"

  #库的地址
  s.source       = { :git => "https://github.com/tigerAndBull/TABCardView.git", :tag => "0.0.2" }

  s.source_files = 'TABCardProject/TABCardView/**/*.{h,m}'

end
