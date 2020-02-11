package com.yag.openbeatsmobile;

import android.app.ActivityManager;
import android.app.DownloadManager;
import android.content.Context;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.widget.Toast;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.io.File;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.yag.openbeatsmobile";
    private int STORAGE_PERMISSION_CODE = 1;
    String videoId, videoTitle;
    private static MethodChannel backwardMChannel = null;
    String downloadPath = Environment.getExternalStorageDirectory() + "/OpenBeatsDownloads/";
    HashMap<String, String> deviceInfo = new HashMap<String, String>();

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
                        } else if (call.method.equals("getDeviceInfo")){
                            getDeviceInfo();
                            result.success(deviceInfo);
                        }
                    }
                }
        );
    }

    // gets the device information and feeds it into the hashMap variable
    void getDeviceInfo(){
        // getting system details
        String OSVersion = System.getProperty("os.version");
        String apiLevel = Build.VERSION.SDK_INT+"";
        String brand = Build.BRAND;
        String deviceModel = Build.MODEL;
        // getting system memory information
        ActivityManager actManager = (ActivityManager) getSystemService(ACTIVITY_SERVICE);
        ActivityManager.MemoryInfo memInfo = new ActivityManager.MemoryInfo();
        actManager.getMemoryInfo(memInfo);
        long totalMemory = memInfo.totalMem;

        DecimalFormat twoDecimalForm = new DecimalFormat("#.##");

        String finalValue = "";

        double kb = totalMemory / 1024.0;
        double mb = totalMemory / 1048576.0;
        double gb = totalMemory / 1073741824.0;
        double tb = totalMemory / 1099511627776.0;

        if (tb > 1) {
            finalValue = twoDecimalForm.format(tb).concat(" TB");
        } else if (gb > 1) {
            finalValue = twoDecimalForm.format(gb).concat(" GB");
        } else if (mb > 1) {
            finalValue = twoDecimalForm.format(mb).concat(" MB");
        }else if(kb > 1){
            finalValue = twoDecimalForm.format(mb).concat(" KB");
        } else {
            finalValue = twoDecimalForm.format(totalMemory).concat(" Bytes");
        }

        // putting values into map variable
        deviceInfo.put("systemApi",apiLevel);
        deviceInfo.put("deviceBrand", brand);
        deviceInfo.put("systemRam", finalValue);
        deviceInfo.put("deviceModel", deviceModel);
    }

    // showRational variable to check if the rational message should be shown after the user clicks OK
    // on the previous rational message
    void checkPermAccessAndStartDownload(boolean showRational) {
        // declaring the permission we need to request
        String permission = android.Manifest.permission.WRITE_EXTERNAL_STORAGE;
        // checking if the permission was already granted
        if (ContextCompat.checkSelfPermission(MainActivity.this, permission) == PackageManager.PERMISSION_GRANTED) {
            Toast.makeText(MainActivity.this, "Download Initiated", Toast.LENGTH_LONG).show();
            startDownload();
        } else {
            requestStoragePermission(permission, showRational);
        }

    }

    private void requestStoragePermission(String permission, boolean showRational) {
        // checks if we should show the dialog to the user
        if (ActivityCompat.shouldShowRequestPermissionRationale(this, permission) && showRational == false) {
            // showing explanation to the user as to why the app needs the permission
            ArrayList<String> parameters = new ArrayList<String>();
            parameters.add(videoId);
            parameters.add(videoTitle);
            backwardMChannel.invokeMethod("showRational", parameters);

        } else {
            ActivityCompat.requestPermissions(this, new String[]{permission}, STORAGE_PERMISSION_CODE);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        // checking if the required permission is granted
        if (requestCode == STORAGE_PERMISSION_CODE) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Toast.makeText(MainActivity.this, "Download Initiated", Toast.LENGTH_LONG).show();
                startDownload();
            } else {
                Toast.makeText(this, "Please grant permission to download file", Toast.LENGTH_SHORT).show();
            }
        }
    }

    void startDownload() {
        if (isExternalStorageAvailable() && !isExternalStorageReadOnly()) {
            makeSureFileExists();
            String downloadURL = "https://api.openbeats.live/downcc/" + videoId;
            Log.d("Downloads", downloadURL);
            // creating download manager instance
            DownloadManager.Request request = new DownloadManager.Request(Uri.parse(downloadURL));
            request.setAllowedNetworkTypes(DownloadManager.Request.NETWORK_MOBILE | DownloadManager.Request.NETWORK_WIFI);
            request.allowScanningByMediaScanner();
            request.setTitle("Downloading");
            request.setDescription(videoTitle);
            request.setMimeType("audio/mpeg");
            request.setAllowedOverMetered(true);
            request.setAllowedOverRoaming(true);
            request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
//            request.setDestinationInExternalPublicDir(downloadPath, videoTitle + "@OpenBeats.mp3");
            request.setDestinationUri(Uri.fromFile(new File(downloadPath, videoTitle + "@OpenBeats.mp3")));
            // get download service and enqueue file
            DownloadManager manager = (DownloadManager) getSystemService(Context.DOWNLOAD_SERVICE);
            manager.enqueue(request);
        } else {
            Toast.makeText(this, "External Storage not accessible", Toast.LENGTH_SHORT).show();
        }
    }

    void makeSureFileExists() {
        File f = new File(downloadPath);
        if (!f.exists()) {
            f.mkdir();
        }

    }

    private static boolean isExternalStorageReadOnly() {
        String extStorageState = Environment.getExternalStorageState();
        if (Environment.MEDIA_MOUNTED_READ_ONLY.equals(extStorageState)) {
            return true;
        }
        return false;
    }

    private static boolean isExternalStorageAvailable() {
        String extStorageState = Environment.getExternalStorageState();
        if (Environment.MEDIA_MOUNTED.equals(extStorageState)) {
            return true;
        }
        return false;
    }

}
