package com.kcrason.wan_android_flutter;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.ObjectAnimator;
import android.view.View;
import android.view.animation.AccelerateInterpolator;
import android.widget.ProgressBar;


public class SlowlyProgressBar {

    private ProgressBar progressBar;

    private boolean isStart = false;

    public SlowlyProgressBar(ProgressBar progressBar) {
        this.progressBar = progressBar;
    }

    public void onProgressStart() {
        progressBar.setVisibility(View.VISIBLE);
        progressBar.setAlpha(1.0f);
    }

    public void onProgressChange(int newProgress) {
        int currentProgress = progressBar.getProgress();
        if (newProgress >= 100 && !isStart) {
            isStart = true;
            progressBar.setProgress(newProgress);
            startDismissAnimation(progressBar.getProgress());
        } else {
            startProgressAnimation(newProgress, currentProgress);
        }
    }

    private void startProgressAnimation(int newProgress, int currentProgress) {
        ObjectAnimator animator = ObjectAnimator.ofInt(progressBar, "progress", currentProgress, newProgress);
        animator.setDuration(800);
        animator.setInterpolator(new AccelerateInterpolator());
        animator.start();
    }

    private void startDismissAnimation(final int progress) {
        ObjectAnimator anim = ObjectAnimator.ofFloat(progressBar, "alpha", 1.0f, 0.0f);
        anim.setDuration(600);
        anim.setInterpolator(new AccelerateInterpolator());

        anim.addUpdateListener(valueAnimator -> {
            float fraction = valueAnimator.getAnimatedFraction();
            int offset = 100 - progress;
            progressBar.setProgress((int) (progress + offset * fraction));
        });

        anim.addListener(new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                progressBar.setProgress(0);
                progressBar.setVisibility(View.GONE);
                isStart = false;
            }
        });
        anim.start();
    }
}



