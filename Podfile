# Uncomment the next line to define a global platform for your project
 platform :ios, '10.0'
use_frameworks!
def shared_pods
  pod 'Alamofire'
  pod 'AlamofireImage'
  pod 'RealmSwift'
  pod 'TPKeyboardAvoiding'
  pod 'SwiftMessages'
end
target 'Musica' do
  shared_pods
  # Pods for Musica
  target 'MusicaTests' do
    inherit! :search_paths
    # Pods for testing
  end
end

target 'MusicaUITests' do
  shared_pods
  # Pods for testing
  end
