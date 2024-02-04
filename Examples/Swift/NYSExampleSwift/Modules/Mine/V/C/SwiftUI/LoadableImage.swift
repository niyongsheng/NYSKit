/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct LoadableImage: View {
    var imageMetadata: Panda
    
    var body: some View {
        if #available(iOS 15.0, *) {
            AsyncImage(url: imageMetadata.imageUrl) { phase in 
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .accessibility(hidden: false)
                        .accessibilityLabel(Text(imageMetadata.description))
                }  else if phase.error != nil  {
                    VStack {
                        Image("pandaplaceholder")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 300)
                        Text("The pandas were all busy.")
                            .font(.title2)
                        Text("Please try again.")
                            .font(.title3)
                    }
                    
                } else {
                    ProgressView()
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

struct Panda_Previews: PreviewProvider {
    static var previews: some View {
        LoadableImage(imageMetadata: Panda.defaultPanda)
    }
}
