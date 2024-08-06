package com.example.timer;

import android.app.Service;
import android.content.Intent;
import android.os.Handler;
import android.os.IBinder;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.widget.TextView;

public class OverlayService extends Service {
    private View overlayView;
    private Handler handler = new Handler();
    private int countdownTime = 10; // Change this value to match your initial countdown time

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        overlayView = LayoutInflater.from(this).inflate(R.layout.overlay_layout, null);

        WindowManager.LayoutParams params = new WindowManager.LayoutParams(
                WindowManager.LayoutParams.MATCH_PARENT,
                WindowManager.LayoutParams.MATCH_PARENT,
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
                WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL | WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                -3
        );

        WindowManager wm = (WindowManager) getSystemService(WINDOW_SERVICE);
        wm.addView(overlayView, params);

        // Start the countdown
        startCountdown();
    }

    private void startCountdown() {
        final TextView timerTextView = overlayView.findViewById(R.id.overlay_timer);
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                if (countdownTime > 0) {
                    timerTextView.setText(String.valueOf(countdownTime));
                    countdownTime--;
                    handler.postDelayed(this, 1000);
                } else {
                    stopSelf();
                }
            }
        }, 1000);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (overlayView != null) {
            WindowManager wm = (WindowManager) getSystemService(WINDOW_SERVICE);
            wm.removeView(overlayView);
            overlayView = null;
        }
        handler.removeCallbacksAndMessages(null);
    }
}
