package tkFrameworkTestSuite.tests {

    import org.flexunit.Assert;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkframework.collision.TkCollisionShape;
    import tatsuyakoyama.tkframework.collision.TkCollisionShapeAABB;
    import tatsuyakoyama.tkframework.collision.TkCollisionShapeOBB;
    import tatsuyakoyama.tkframework.collision.TkCollisionShapeSphere;
    import tatsuyakoyama.tkutility.TkUtil;

    public class TkCollisionShapeTestCase {

        private var onCollide:Function = function():void {};
        private var actorA:TkActor = new TkActor();
        private var actorB:TkActor = new TkActor();
        private var aabbA:TkCollisionShapeAABB;
        private var aabbB:TkCollisionShapeAABB;
        private var obbA:TkCollisionShapeOBB;
        private var obbB:TkCollisionShapeOBB;
        private var sphereA:TkCollisionShapeSphere;
        private var sphereB:TkCollisionShapeSphere;

        [Before]
        public function runBeforeTest():void {
            aabbA = new TkCollisionShapeAABB(
                actorA, onCollide, 200, 100, 0, 0
            );
            aabbB = new TkCollisionShapeAABB(
                actorB, onCollide, 200, 400, 0, 0
            );
            obbA = new TkCollisionShapeOBB(
                actorA, onCollide, 200, 100, 0, 0
            );
            obbB = new TkCollisionShapeOBB(
                actorB, onCollide, 200, 400, 0, 0
            );
            sphereA = new TkCollisionShapeSphere(
                actorA, onCollide, 100, 0, 0
            );
            sphereB = new TkCollisionShapeSphere(
                actorB, onCollide, 200, 0, 0
            );
        }

        [Test]
        public function hitTestAABBvsAABB_1():void {
            actorA.x = 0;
            actorA.y = 0;

            actorB.x = -250;
            actorB.y = 250;

            var isHit:Boolean = aabbA.hitTest(aabbB);
            Assert.assertEquals(isHit, false);
        }

        [Test]
        public function hitTestAABBvsAABB_2():void {
            actorA.x = 0;
            actorA.y = 0;

            actorB.x = -190;
            actorB.y = 250;

            var isHit:Boolean = aabbA.hitTest(aabbB);
            Assert.assertEquals(isHit, true);
        }

        [Test]
        public function hitTestOBBvsOBB_1():void {
            actorA.x = 0;
            actorA.y = 0;
            actorA.rotation = TkUtil.deg2rad(45);

            actorB.x = -300;
            actorB.y = 0;
            actorB.rotation = TkUtil.deg2rad(0);

            var isHit:Boolean = obbA.hitTest(obbB);
            Assert.assertEquals(isHit, false);
        }

        [Test]
        public function hitTestOBBvsOBB_2():void {
            actorA.x = 0;
            actorA.y = 0;
            actorA.rotation = TkUtil.deg2rad(45);

            actorB.x = -200;
            actorB.y = 0;
            actorB.rotation = TkUtil.deg2rad(-45);

            var isHit:Boolean = obbA.hitTest(obbB);
            Assert.assertEquals(isHit, true);
        }

        [Test]
        public function hitTestSphereVsSphere_1():void {
            actorA.x = 0;
            actorA.y = 0;

            actorB.x = -300;
            actorB.y = -10;

            var isHit:Boolean = sphereA.hitTest(sphereB);
            Assert.assertEquals(isHit, false);
        }

        [Test]
        public function hitTestSphereVsSphere_2():void {
            actorA.x = 0;
            actorA.y = 0;

            actorB.x = -290;
            actorB.y = 0;

            var isHit:Boolean = sphereA.hitTest(sphereB);
            Assert.assertEquals(isHit, true);
        }

        [Test]
        public function hitTestAABBVsOBB_1():void {
            actorA.x = -210;
            actorA.y = 0;

            actorB.x = 0;
            actorB.y = 0;
            actorB.rotation = TkUtil.deg2rad(-30);

            var isHit:Boolean = aabbA.hitTest(obbB);
            Assert.assertEquals(isHit, true);
        }

        [Test]
        public function hitTestAABBVsSphere_1():void {
            actorA.x = -190;
            actorA.y = 0;

            actorB.x = 0;
            actorB.y = 0;

            var isHit:Boolean = aabbA.hitTest(sphereB);
            Assert.assertEquals(isHit, true);
        }

        [Test]
        public function hitTestOBBVsSphere_1():void {
            actorA.x = -200;
            actorA.y = 0;
            actorA.rotation = TkUtil.deg2rad(30);

            actorB.x = 0;
            actorB.y = 0;

            var isHit:Boolean = obbA.hitTest(sphereB);
            Assert.assertEquals(isHit, true);
        }
    }
}
