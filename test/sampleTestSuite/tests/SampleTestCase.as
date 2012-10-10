package sampleTestSuite.tests {

    import org.flexunit.Assert;

    public class SampleTestCase {

        [Test(description = "This tests addition")]
        public function simpleAdd():void {
            var x:int = 5 + 3;
            Assert.assertEquals(8, x);
        }
    }
}
