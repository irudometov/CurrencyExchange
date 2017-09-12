use_frameworks!
inhibit_all_warnings!
platform :ios, '8.0'

project 'CurrencyExchange/CurrencyExchange.xcodeproj'
workspace 'CurrencyExchange.xcworkspace'

def required_pods

    pod 'AFNetworking'
    pod 'XMLDictionary'
    
end

target 'CurrencyExchange' do
    required_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        puts target.name
    end
end
