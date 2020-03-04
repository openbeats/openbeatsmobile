package com.yag.openbeatsmobile;

import android.app.ActivityManager;
import android.app.DownloadManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.provider.Settings;
import android.util.Log;
import android.widget.Toast;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;

import java.io.File;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

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
    String TAG = "com.yag.openbeatsmobile";
    boolean downCompleteTriggered = false;
    static final int INSTALL_UNKNOWNAPP_PERMISSION_CODE = 1;
    String apkURL, updateName;
    // variable to store which storage requiring activity is invoking the storage permission request
    String storageReqAct = "";
    boolean showRational;
    // holds the shared video parameters
    String sharedParameters;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        backwardMChannel = new MethodChannel(MainActivity.this.getFlutterView(), CHANNEL);
        // intent instance to handle shared media instances
        Intent intent = getIntent();
        // getting data from intent
        Uri data = intent.getData();
        // if there is shared data
        if (data != null) {
            // extracting data from the url
            // splitting string based on / separators
            String[] mainArr = data.toString().split("~~~~");
            // splitting the array parameters based on |
            sharedParameters = mainArr[1];

        } else {
            Log.d(TAG, "onCreate: Null Intent");
        }
        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        if (call.method.equals("showToast")) {
                            String message = call.argument("message");
                            Toast.makeText(MainActivity.this, message, Toast.LENGTH_LONG).show();
                        } else if (call.method.equals("startDownload")) {
                            storageReqAct = "startDownload";
                            videoId = call.argument("videoId");
                            videoTitle = call.argument("videoTitle");
                            showRational = call.argument("showRational");
                            checkPermAccessAndStartDownload(showRational);
                        } else if (call.method.equals("getDeviceInfo")) {
                            getDeviceInfo();
                            result.success(deviceInfo);
                        } else if (call.method.equals("checkStoragePermission")) {
                            String permission = android.Manifest.permission.WRITE_EXTERNAL_STORAGE;
                            // checking if the permission was already granted
                            if (ContextCompat.checkSelfPermission(MainActivity.this, permission) == PackageManager.PERMISSION_GRANTED) {
                                result.success("Access Granted");
                            } else {
                                result.success("Access Denied");
                            }
                        } else if (call.method.equals("downloadUpdate")) {
                            apkURL = call.argument("apkURL");
                            updateName = call.argument("updateName");
                            storageReqAct = "downloadUpdate";
                            showRational = call.argument("showRational");
                            // checking if install app from unknown sources is allowed
                            // returns false for everything below Oreo
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                                if (!getPackageManager().canRequestPackageInstalls()) {
                                    Toast.makeText(MainActivity.this, "Please grant permission to install app", Toast.LENGTH_LONG).show();
                                    // creating intent to send user to get permission to install unknown apps
                                    Intent installUnknownApps = new Intent(android.provider.Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES, Uri.parse("package:com.yag.openbeatsmobile"));
                                    // sending user to get permission
                                    startActivityForResult(installUnknownApps, INSTALL_UNKNOWNAPP_PERMISSION_CODE);
                                } else {
                                    getStoragePermissionApkUpdate();
                                }
                            } else {
                                getStoragePermissionApkUpdate();
                            }
                        } else if (call.method.equals("getStoragePermission")) {
                            // declaring the permission we need to request
                            String permission = android.Manifest.permission.WRITE_EXTERNAL_STORAGE;
                            // checking if the permission was already granted
                            if (ContextCompat.checkSelfPermission(MainActivity.this, permission) == PackageManager.PERMISSION_GRANTED) {
                                result.success("Permission Granted");
                            } else {
                                // checks if we should show the dialog to the user
                                if (ActivityCompat.shouldShowRequestPermissionRationale(MainActivity.this, permission)) {
                                    Toast.makeText(MainActivity.this, "Please enable storage permission from settings", Toast.LENGTH_LONG).show();
                                    openStorageSettingsPage();
                                } else {
                                    ActivityCompat.requestPermissions(MainActivity.this, new String[]{permission}, STORAGE_PERMISSION_CODE);
                                }
                            }
                        } else if (call.method.equals("getListOfDownloadedAudio")) {
                            result.success(getListOfDownloadedAudio());
                        } else if (call.method.equals("getSharedMediaParameters")) {
                            result.success(sharedParameters);
                        }
                    }
                }
        );
    }

    // returns the list of downloaded audio
    List<String> getListOfDownloadedAudio(){
        // shared preferences instance to check validity of the downloaded audio if there are any
        SharedPreferences pref = getApplicationContext().getSharedPreferences(getPackageName(), 0); // 0 - for private mode
        // holds the list of files in local storage
        List<String> audioList = new ArrayList<String>(),tempList = new ArrayList<String>();
        // setting path to the download variable
        String path = Environment.getExternalStorageDirectory().toString() + "/OpenBeatsDownloads/";
        // creating a directory with the path
        File directory = new File(path);
        // checking if directory exists
        if (directory.exists()) {
            // getting list of files in directory to FILE array instance
            File[] files = directory.listFiles();
            if (files.length > 0) {
                // storing file list in array
                tempList = Arrays.asList(directory.list());
                // removing items that are not in shared preferences
                for(int i=0;i<tempList.size();i++){
                    String audioTitle = tempList.get(i).replace("@OpenBeats.mp3","");
                    Log.d(TAG, "downloadedMedia"+audioTitle);
                    Log.d(TAG, pref.getString("downloadedMedia"+audioTitle,null));
                    if(pref.getString("downloadedMedia"+audioTitle,null) != null)
                        audioList.add(tempList.get(i));
                }
                // checking if the list is empty and appending template
                if(audioList.size() == 0)
                    audioList.add("No Downloaded Files");
            } else
                audioList.add("No Downloaded Files");
        } else
            audioList.add("No Downloaded Files");
        return audioList;
    }

    void openStorageSettingsPage() {
        Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
//        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        Uri uri = Uri.fromParts("package", getPackageName(), null);
        intent.setData(uri);
        startActivity(intent);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        // Check which request we're responding to
        if (requestCode == INSTALL_UNKNOWNAPP_PERMISSION_CODE) {
            // Make sure the request was successful
            if (resultCode == RESULT_OK) {
                getStoragePermissionApkUpdate();
            }
        }
    }

    void getStoragePermissionApkUpdate() {
        Log.d(TAG, "getStoragePermissionApkUpdate: Reached");
        // declaring the permission we need to request
        String permission = android.Manifest.permission.WRITE_EXTERNAL_STORAGE;
        // checking if the permission was already granted
        if (ContextCompat.checkSelfPermission(MainActivity.this, permission) == PackageManager.PERMISSION_GRANTED) {
            downloadApk();
        } else {
            requestStoragePermission(permission, showRational);
        }
    }

    // downloads the latest version of the apk
    void downloadApk() {
        Log.d(TAG, "downloadApk: GOt here");
        //get destination to update file and set Uri
        String destination = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS) + "/";
        String fileName = "app-release.apk";
        destination += fileName;
        final Uri uri = Uri.parse("file://" + destination);

        //Delete update file if exists
        File file = new File(destination);
        if (file.exists()) {
            Log.d(TAG, "downloadApk: File Exists, deleting");
            file.delete();
        }

        DownloadManager.Request request = new DownloadManager.Request(Uri.parse(apkURL))
                .setTitle("OpenBeats v" + updateName)
                .setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE)
                .setDestinationUri(Uri.fromFile(file));
        DownloadManager downloadManager = (DownloadManager) getSystemService(DOWNLOAD_SERVICE);
        downloadManager.enqueue(request);

        BroadcastReceiver onComplete = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                if (file.exists() && downCompleteTriggered == false) {
                    Toast.makeText(context, "Initializing update install", Toast.LENGTH_SHORT).show();
                    Intent intent2;
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                        Log.d(TAG, "downloadApk: " + file.getAbsolutePath());
                        Uri apkUri = FileProvider.getUriForFile(MainActivity.this, "openbeats.fileProvider", file);
                        intent2 = new Intent(Intent.ACTION_INSTALL_PACKAGE);
                        intent2.setData(apkUri);
                        intent2.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                    } else {
                        Uri apkUri = Uri.fromFile(file);
                        intent2 = new Intent(Intent.ACTION_VIEW);
                        intent2.setDataAndType(apkUri, "application/vnd.android.package-archive");
                        intent2.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                    }
                    MainActivity.this.startActivity(intent2);
                    downCompleteTriggered = true;
                }
            }
        };
        registerReceiver(onComplete, new IntentFilter(DownloadManager.ACTION_DOWNLOAD_COMPLETE));
    }

    // gets the device information and feeds it into the hashMap variable
    void getDeviceInfo() {
        // getting system details
        String OSVersion = System.getProperty("os.version");
        String apiLevel = Build.VERSION.SDK_INT + "";
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
        } else if (kb > 1) {
            finalValue = twoDecimalForm.format(mb).concat(" KB");
        } else {
            finalValue = twoDecimalForm.format(totalMemory).concat(" Bytes");
        }

        // putting values into map variable
        deviceInfo.put("systemApi", apiLevel);
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
            parameters.add(storageReqAct);
            backwardMChannel.invokeMethod("showRational", parameters);

        } else {
            ActivityCompat.requestPermissions(this, new String[]{permission}, STORAGE_PERMISSION_CODE);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        // checking if the required permission is granted
        if (requestCode == STORAGE_PERMISSION_CODE && storageReqAct == "startDownload") {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Toast.makeText(MainActivity.this, "Download Initiated", Toast.LENGTH_LONG).show();
                startDownload();
            } else {
                Toast.makeText(this, "Please grant permission to download file", Toast.LENGTH_SHORT).show();
            }
        } else if (requestCode == STORAGE_PERMISSION_CODE && storageReqAct == "downloadUpdate") {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Toast.makeText(MainActivity.this, "Update downloading...", Toast.LENGTH_LONG).show();
                downloadApk();
            } else {
                Toast.makeText(this, "Please grant permission to download update", Toast.LENGTH_SHORT).show();
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

            // download complete listener to add file information to shared preferences
            BroadcastReceiver onCompleteMediaDownload = new BroadcastReceiver() {
                public void onReceive(Context context, Intent intent) {
                    SharedPreferences pref = getApplicationContext().getSharedPreferences(getPackageName(), 0); // 0 - for private mode
                    SharedPreferences.Editor editor = pref.edit();
                    Log.d("Testing","downloadedMedia"+videoTitle);
                    editor.putString("downloadedMedia"+videoTitle, videoId);
                }
            };
            registerReceiver(onCompleteMediaDownload, new IntentFilter(DownloadManager.ACTION_DOWNLOAD_COMPLETE));
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
