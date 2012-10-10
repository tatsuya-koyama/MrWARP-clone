package tkUtilityTestSuite.tests {

    import org.flexunit.Assert;
    import mx.utils.ObjectUtil;

    import tatsuyakoyama.tkutility.TkUtil;

    public class TkUtilTestCase {

        [Test]
        public function test_flattenObject():void {
            var srcObj:Object = {
                hoge: 123,
                fuga: {
                    piyo: {
                        foo: 456,
                        bar: true
                    },
                    foobar: 0
                },
                hogehoge: null
            };

            var expectedObj:Object = {
                'hoge'          : 123,
                'fuga.piyo.foo' : 456,
                'fuga.piyo.bar' : true,
                'fuga.foobar'   : 0,
                hogehoge        : null
            };

            var testingObj:Object = TkUtil.flattenObject(srcObj);
            Assert.assertEquals(0, ObjectUtil.compare(testingObj, expectedObj));
        }

    }
}
