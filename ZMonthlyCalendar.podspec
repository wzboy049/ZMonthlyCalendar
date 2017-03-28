Pod::Spec.new do |s|
s.name             = 'ZMonthlyCalendar'
s.version          = '0.0.1'
s.summary          = 'not Calendar just show messge by month , scroll by year.'

s.description      = <<-DESC
not Calendar just show messge by month , scroll by year 一个简单的顶部滚动控件 上面显示年份,点击某一年可以加载对应年的数据,再点击一下就展开月份视图 点击月份 滚动到对应的cell 需要的自己拿去改一下
DESC

s.homepage         = 'https://github.com/wzboy049/ZMonthlyCalendar'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'wzboy' => 'wzboy005@sina.com' }
s.source           = { :git => 'https://github.com/wzboy049/ZMonthlyCalendar.git', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'
s.source_files = 'ZMonthlyCalendar/*.swift'
s.resource     = 'ZMonthlyCalendar/Resource/*'

end
