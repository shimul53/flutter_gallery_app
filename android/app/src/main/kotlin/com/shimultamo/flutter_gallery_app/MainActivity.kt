package com.shimultamo.flutter_gallery_app



import android.os.Bundle
import android.provider.MediaStore
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.shimultamo.flutter_gallery_app"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getAlbums" -> {
                        val albums = getAlbums()
                        result.success(albums)
                    }
                    "getImagesForAlbum" -> {
                        val albumName = call.argument<String>("albumName")
                        val images = getImagesForAlbum(albumName)
                        result.success(images)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun getAlbums(): List<Map<String, Any>> {
        val albumList = mutableListOf<Map<String, Any>>()
        //  store "bucketName" -> (count, firstImagePath)
        data class AlbumData(var count: Int, var thumbnailPath: String?)

        val albumMap = hashMapOf<String, AlbumData>()

        val projection = arrayOf(
            MediaStore.Images.Media.DATA,
            MediaStore.Images.Media.BUCKET_DISPLAY_NAME,
            MediaStore.Images.Media.DATE_ADDED
        )

        // Sort newest first so the first time view album, that path is the "thumbnail"
        val sortOrder = "${MediaStore.Images.Media.DATE_ADDED} DESC"

        val cursor = contentResolver.query(
            MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
            projection,
            "${MediaStore.Images.Media.BUCKET_DISPLAY_NAME} IS NOT NULL",
            null,
            sortOrder
        )

        cursor?.use {
            val dataIndex = it.getColumnIndexOrThrow(MediaStore.Images.Media.DATA)
            val bucketIndex = it.getColumnIndexOrThrow(MediaStore.Images.Media.BUCKET_DISPLAY_NAME)

            while (it.moveToNext()) {
                val path = it.getString(dataIndex)
                val bucketName = it.getString(bucketIndex) ?: "Unknown"

                val albumData = albumMap[bucketName]
                if (albumData == null) {
                    //set this path as the thumbnail
                    albumMap[bucketName] = AlbumData(count = 1, thumbnailPath = path)
                } else {
                    albumData.count += 1
                    // keep existing thumbnailPath (most recent)
                }
            }
        }

        // Build the final list
        for ((bucketName, data) in albumMap) {
            albumList.add(
                mapOf(
                    "name" to bucketName,
                    "count" to data.count,
                    "thumbnailPath" to (data.thumbnailPath ?: "")
                )
            )
        }

        return albumList
    }

    private fun getImagesForAlbum(albumName: String?): List<String> {
        if (albumName == null) return emptyList()

        val imageList = mutableListOf<String>()
        val projection = arrayOf(
            MediaStore.Images.Media.DATA,
            MediaStore.Images.Media.BUCKET_DISPLAY_NAME
        )
        val selection = "${MediaStore.Images.Media.BUCKET_DISPLAY_NAME} = ?"
        val selectionArgs = arrayOf(albumName)
        val sortOrder = "${MediaStore.Images.Media.DATE_ADDED} DESC"

        val cursor = contentResolver.query(
            MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
            projection,
            selection,
            selectionArgs,
            sortOrder
        )

        cursor?.use {
            val dataIndex = it.getColumnIndexOrThrow(MediaStore.Images.Media.DATA)
            while (it.moveToNext()) {
                val path = it.getString(dataIndex)
                imageList.add(path)
            }
        }
        return imageList
    }
}
