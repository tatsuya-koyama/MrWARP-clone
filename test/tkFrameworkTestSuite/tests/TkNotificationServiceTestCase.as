package tkFrameworkTestSuite.tests {

    import org.flexunit.Assert;

    import tatsuyakoyama.tkframework.TkGameObject;
    import tatsuyakoyama.tkframework.TkNotificationService;

    public class TkNotificationServiceTestCase {

        [Test]
        public function testBroadcast():void {
            var notificationService:TkNotificationService = new TkNotificationService();
            var subscriber:TkGameObject = new TkGameObject();

            var result:int = 0;
            var callback:Function = function(eventArg:Object):void {
                result = eventArg.val;
            }
            notificationService.addListener(
                subscriber, 'hoge_msg', callback
            );
            notificationService.postMessage(
                'hoge_msg', {val: 123}
            );
            notificationService.broadcastMessage();

            Assert.assertEquals(result, 123);
        }

    }
}
