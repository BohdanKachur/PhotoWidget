//
//  PhotoFrame.swift
//  PhotoFrame
//
//  Created by Bohdan Kachur on 22.09.2020.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    
    typealias Entry = PhotoEntry
    var nextUpdateDate = Date()
    
    func placeholder(in context: Context) -> PhotoEntry {
        PhotoEntry(date: Date(), photo: PhotoModel(imageFileName: nil))
    }

    func getSnapshot(in context: Context, completion: @escaping (PhotoEntry) -> ()) {
        let entry = PhotoEntry(date: Date(), photo: PhotoModel(imageFileName: nil))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [PhotoEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        var nextUpdateDate = Date()
        let photos = PhotoSelectionStore.shared.loadPhotos()
        let refreshInterval = PhotoSelectionStore.shared.refreshInterval
        
        if (photos.count > 0) {
            if refreshInterval == .never {
                let entry = PhotoEntry(date: nextUpdateDate, photo: photos[0])
                entries.append(entry)
            }
            else {
                for photo in photos {
           
                    let entry = PhotoEntry(date: nextUpdateDate, photo: photo)
                    entries.append(entry)
                    nextUpdateDate = Calendar.current.date(byAdding: .minute, value: refreshInterval.minutesInterval, to: nextUpdateDate)!
                }
            }
        }
        
        let timeline = Timeline(entries: entries, policy: .after(nextUpdateDate))
        completion(timeline)
    }
}

struct PhotoEntry: TimelineEntry {
    let date: Date
    let photo: PhotoModel
}

struct PhotoFrameEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            if entry.photo.imageFileName == nil {
            Image("Placeholder")
                            .resizable()
                .aspectRatio(contentMode: .fill)
                            .mask(
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .frame(minHeight: 0, maxHeight: .infinity)
                            )
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(minHeight: 0, maxHeight: .infinity)
        }
        else
            {
                entry.photo.image!
                                .resizable()
                    .aspectRatio(contentMode: .fill)
                                .mask(
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .frame(minHeight: 0, maxHeight: .infinity)
                                )
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .frame(minHeight: 0, maxHeight: .infinity)
            }
    }
}
}

@main
struct PhotoFrame: Widget {
    let kind: String = "PhotoFrame"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PhotoFrameEntryView(entry: entry)
        }
        .configurationDisplayName("Photo Widget")
        .description("This is an example widget.")
    }
}

struct PhotoFrame_Previews: PreviewProvider {
    static var previews: some View {
        PhotoFrameEntryView(entry: PhotoEntry(date: Date(), photo: PhotoModel(imageFileName: nil)))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
