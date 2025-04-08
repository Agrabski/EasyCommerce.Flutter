package biz.grabski.easy_commerce

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import com.google.firebase.ktx.*
import com.google.firebase.appdistribution.*
import com.google.firebase.appdistribution.ktx.*

class MainActivity: FlutterActivity(){
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Firebase.appDistribution.showFeedbackNotification(
            // Text providing notice to your testers about collection and
            // processing of their feedback data
            "Your feedback will be collected by firebase",
            // The level of interruption for the notification
            InterruptionLevel.HIGH)
    }
}
