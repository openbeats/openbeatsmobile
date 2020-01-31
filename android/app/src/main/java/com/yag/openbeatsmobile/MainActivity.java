package com.yag.openbeatsmobile;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DownloadManager;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.util.ArrayList;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.yag.openbeatsmobile";
    private int STORAGE_PERMISSION_CODE = 1;
    String videoId, videoTitle;
    private static MethodChannel backwardMChannel = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        backwardMChannel = new MethodChannel(MainActivity.this.getFlutterView(), CHANNEL);
        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        if (call.method.equals("showToast")) {
                            String message = call.argument("message");
                            Toast.makeText(MainActivity.this, message, Toast.LENGTH_LONG).show();
                        } else if (call.method.equals("startDownload")) {
                            videoId = call.argument("videoId");
                            videoTitle = call.argument("videoTitle");
                            boolean showRational = call.argument("showRational");
                            checkPermAccessAndStartDownload(showRational);
                        }
                    }
                }
        );
    }

    // showRational variable to check if the rational message should be shown after the user clicks OK
    // on the previous rational message
    void checkPermAccessAndStartDownload(boolean showRational){
        // declaring the permission we need to request
        String permission = android.Manifest.permission.WRITE_EXTERNAL_STORAGE;
        // checking if the permission was already granted
        if(ContextCompat.checkSelfPermission(MainActivity.this,permission) == PackageManager.PERMISSION_GRANTED){
            Toast.makeText(MainActivity.this, "Download Initiated", Toast.LENGTH_LONG).show();
            startDownload();
        } else {
            requestStoragePermission(permission, showRational);
        }

    }

    private void requestStoragePermission(String permission, boolean showRational){
        // checks if we should show the dialog to the user
        if(ActivityCompat.shouldShowRequestPermissionRationale(this,permission) && showRational == false) {
            // showing explanation to the user as to why the app needs the permission
            ArrayList<String> parameters = new ArrayList<String>();
            parameters.add(videoId);
            parameters.add(videoTitle);
            backwardMChannel.invokeMethod("showRational",parameters);

        } else {
            ActivityCompat.requestPermissions(this, new String[] {permission}, STORAGE_PERMISSION_CODE);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        // checking if the required permission is granted
        if(requestCode == STORAGE_PERMISSION_CODE){
            if(grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED){
//                Toast.makeText(this, "Permission Granted", Toast.LENGTH_SHORT).show();
                startDownload();
            } else {
                Toast.makeText(this, "Please grant permission to download file", Toast.LENGTH_SHORT).show();
            }
        }
    }

    void startDownload(){
        String downloadURL = "https://api.openbeats.live/downcc/"+videoId;
        // creating download manager instance
        DownloadManager.Request request = new DownloadManager.Request(Uri.parse(downloadURL));
        request.setAllowedNetworkTypes(DownloadManager.Request.NETWORK_MOBILE | DownloadManager.Request.NETWORK_WIFI);
        request.allowScanningByMediaScanner();
        request.setTitle("Downloading");
        request.setDescription(videoTitle);
        request.setMimeType("audio/mpeg");
        request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
        request.setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS, videoTitle+"@OpenBeats.mp3");

        // get download service and enqueue file
        DownloadManager manager = (DownloadManager) getSystemService(Context.DOWNLOAD_SERVICE);
        manager.enqueue(request);
    }

}
