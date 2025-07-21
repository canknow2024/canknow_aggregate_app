package com.canknow.canknow_aggregate_app;

import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import androidx.core.content.FileProvider;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import java.io.File;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "install_apk_plugin";

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("getPlatformVersion")) {
                        result.success("Android " + android.os.Build.VERSION.RELEASE);
                    } else if (call.method.equals("installApk")) {
                        String apkPath = call.argument("path");
                        installApk(apkPath, result);
                    } else {
                        result.notImplemented();
                    }
                }
            );
    }

    private void installApk(String apkPath, MethodChannel.Result result) {
        try {
            File apkFile = new File(apkPath);
            if (!apkFile.exists()) {
                result.error("FILE_NOT_FOUND", "APK文件不存在: " + apkPath, null);
                return;
            }

            Intent intent = new Intent(Intent.ACTION_VIEW);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            
            Uri apkUri;
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                // Android 7.0及以上需要使用FileProvider
                apkUri = FileProvider.getUriForFile(
                    this, 
                    getApplicationContext().getPackageName() + ".fileprovider", 
                    apkFile
                );
                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            } else {
                apkUri = Uri.fromFile(apkFile);
            }
            
            intent.setDataAndType(apkUri, "application/vnd.android.package-archive");
            
            startActivity(intent);
            result.success(true);
            
        } catch (Exception e) {
            result.error("INSTALL_FAILED", "安装失败: " + e.getMessage(), null);
        }
    }
}
