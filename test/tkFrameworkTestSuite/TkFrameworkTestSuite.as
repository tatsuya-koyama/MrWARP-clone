package tkFrameworkTestSuite {

    import tkFrameworkTestSuite.tests.TkCollisionShapeTestCase;
    import tkFrameworkTestSuite.tests.TkNotificationServiceTestCase;
    import tkFrameworkTestSuite.tests.TkStateMachineTestCase;

    [Suite]
    [RunWith("org.flexunit.runners.Suite")]
    public class TkFrameworkTestSuite {
        public var test_01:TkCollisionShapeTestCase;
        public var test_02:TkNotificationServiceTestCase;
        public var test_03:TkStateMachineTestCase;
    }
}
