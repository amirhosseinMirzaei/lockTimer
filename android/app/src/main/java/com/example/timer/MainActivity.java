package com.example.timer;

import android.app.ActivityManager;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.timer/lock";

    private View overlayView;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("startLockTask")) {
                                startLockTaskMode();
                                result.success(null);
                            } else if (call.method.equals("stopLockTask")) {
                                stopLockTaskMode();
                                result.success(null);
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        overlayView = new View(this);
        overlayView.setBackgroundColor(0x80FFFFFF); // Semi-transparent white overlay
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (isTaskLocked()) {
            showOverlay();
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        hideOverlay();
    }

    private void startLockTaskMode() {
        ActivityManager am = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
        if (am.getLockTaskModeState() == ActivityManager.LOCK_TASK_MODE_NONE) {
            startLockTask();
        }
        showOverlay();
    }

    private void stopLockTaskMode() {
        stopLockTask();
        hideOverlay();
    }

    private void showOverlay() {
        if (overlayView.getParent() == null) {
            addContentView(overlayView, new WindowManager.LayoutParams(
                    WindowManager.LayoutParams.MATCH_PARENT,
                    WindowManager.LayoutParams.MATCH_PARENT
            ));
        }
    }

    private void hideOverlay() {
        if (overlayView.getParent() != null) {
            ((ViewGroup) overlayView.getParent()).removeView(overlayView);
        }
    }

    private boolean isTaskLocked() {
        ActivityManager am = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
        return am.getLockTaskModeState() != ActivityManager.LOCK_TASK_MODE_NONE;
    }
}
