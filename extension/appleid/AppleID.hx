package extension.appleid;

import extension.appleid.ios.AppleIdCFFI;
import extension.util.task.*;

class AppleID extends TaskExecutor {

	static var initted:Bool = false;

	private static var instance: AppleID = null;

	public static function getInstance():AppleID {
		if (instance == null) instance = new AppleID();
		return instance;
	}

	private function new() {
		super();
	}

	public function init() {
		if (initted) return;
		AppleIdCFFI.init();
	}

	public function login(
		onComplete:String->String->String->String->String->Void,
		onFailed:Void->Void,
		onError:String->Void
	) {
		var fOnComplete = function(userId, email, firstName, lastName, token) {
			addTask(new CallStr5Task(onComplete, userId, email, firstName, lastName, token));
		}

		var fOnFailed = function() {
			addTask(new CallTask(onFailed));
		}

		var fOnError = function(error) {
			addTask(new CallStrTask(onError, error));
		}

		AppleIdCFFI.setOnLoginSuccessCallback(fOnComplete);
		AppleIdCFFI.setOnLoginFailedCallback(fOnFailed);
		AppleIdCFFI.setOnLoginErrorCallback(fOnError);

		AppleIdCFFI.login();
	}

	public function available() {
		return AppleIdCFFI.available();
	}

}
