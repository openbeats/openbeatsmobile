package com.yag.openbeatsmobile;

import android.os.Bundle;
import android.widget.Toast;

import androidx.annotation.NonNull;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "com.yag.openbeatsmobile";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);
      GeneratedPluginRegistrant.registerWith(this);
      new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
              new MethodChannel.MethodCallHandler() {
                  @Override
                  public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                      if(call.method.equals("showToast")){
                          String message = call.argument("message");
                          Toast.makeText(MainActivity.this, message, Toast.LENGTH_LONG).show();
                      }
                  }
              }
      );
  }

}
