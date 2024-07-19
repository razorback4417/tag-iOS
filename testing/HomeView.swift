//
//  HomeView.swift
//  testing
//
//  Created by Theo L on 7/13/24.
//
import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    @Binding var showCreateView: Bool
    
    let imageURL = URL(string: "https://images.pexels.com/photos/6273480/pexels-photo-6273480.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Search Bar
                SearchBar(text: $searchText)
                
                // Recent Places
                RecentPlacesView()
                
                // Find a Tag anywhere
                SectionView(title: "Find a Tag anywhere", items: [
                    SectionItem(imageURL: imageURL, title: "Find rides", description: "Split ride costs with verified students"),
                    SectionItem(imageURL: imageURL, title: "Create trip", description: "Create a new trip for others to join", action: { showCreateView = true })
                ])
                
                // Rewards and Deals
                SectionView(title: "Rewards and Deals", items: [
                    SectionItem(imageURL: imageURL, title: "My rewards", description: "Earn rewards for each trip"),
                    SectionItem(imageURL: imageURL, title: "Discover Deals", description: "Find restaurants to get discounts")
                ])
                
                // Join a Friend
                JoinFriendView(imageURL: imageURL)
            }
            .padding()
        }
        .navigationTitle("Home")
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Where to?", text: $text)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct RecentPlacesView: View {
    let recentPlaces = [
        ("Evans Hall", "Berkeley, California"),
//        ("SFO Airport, Terminal One", "San Francisco, California"),
//        ("Embarcadero Station", "San Francisco, California")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recent Places")
                .font(.caption)
                .foregroundColor(.secondary)
            
            ForEach(recentPlaces, id: \.0) { place in
                HStack {
                    Image(systemName: "clock.arrow.circlepath")
                    VStack(alignment: .leading) {
                        Text(place.0)
                            .font(.caption)
                            .fontWeight(.bold)
                        Text(place.1)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Button(action: {
                // Handle show more action
            }) {
                Text("Show more")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.07, green: 0.36, blue: 0.22))
            }
        }
    }
}

struct SectionView: View {
    let title: String
    let items: [SectionItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            
            HStack(spacing: 10) {
                ForEach(items) { item in
                    Button(action: {
                        item.action?()
                    }) {
                        VStack(alignment: .leading) {
                            AsyncImage(url: item.imageURL) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 100)
                                    .clipped()
                                    .cornerRadius(8)
                            } placeholder: {
                                Color.gray
                                    .frame(height: 100)
                                    .cornerRadius(8)
                            }
                            
                            Text(item.title)
                                .font(.caption)
                                .fontWeight(.bold)
                            
                            Text(item.description)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

struct SectionItem: Identifiable {
    let id = UUID()
    let imageURL: URL
    let title: String
    let description: String
    var action: (() -> Void)?
}

struct JoinFriendView: View {
    let imageURL: URL
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Join a Friend")
                .font(.headline)
            
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 80)
                    .clipped()
                    .cornerRadius(8)
            } placeholder: {
                Color.gray
                    .frame(height: 120)
                    .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(showCreateView: .constant(false))
    }
}
