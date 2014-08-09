/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-03-27
 * Time: 21:44
 * To change this template use File | Settings | File Templates.
 */
package deluxe.particles.sd {
import com.genome2d.Genome2D;
import com.genome2d.context.GBlendMode;
import com.genome2d.node.GNode;

import deluxe.particles.BaseGestureParticles;

public class SDGestureParticles extends BaseGestureParticles{

	public function SDGestureParticles(p_node:GNode) {
		super(p_node);
		blendMode = GBlendMode.NORMAL;
		set_textureId("gesture_particle");
		emission = 200;
		emissionDelay = 0;
		emissionTime = 1;
		emissionVariance = 0;
		energyVariance = 0;
		energy = 2;
		dispersionAngle = 10;
		dispersionAngleVariance = 10;
		dispersionXVariance = 8;
		dispersionYVariance = 8;
		initialScale = 1;
		endScale = 1;
		initialScaleVariance = 0;
		endScaleVariance = 0;
		initialVelocity = 0;
		initialVelocityVariance = 0;
		initialAngularVelocity = 0;
		initialAngularVelocityVariance = 0;
		initialAcceleration = 0.001;
		initialAccelerationVariance = 0.01;
		initialAngle = 0;
		initialAngleVariance = 0;
		initialColor = 16777215;
		endColor = 16777215;
		initialAlpha = 1;
		initialAlphaVariance = 0;
		endAlpha = 0;
		endAlphaVariance = 0;
		initialRed = 1;
		initialRedVariance = 0;
		endRed = 1;
		endRedVariance = 0;
		initialGreen = 1;
		initialGreenVariance = 0;
		endGreen = 1;
		endGreenVariance = 0;
		initialBlue = 1;
		initialBlueVariance = 0;
		endBlue = 1;
		endBlueVariance = 0;
		node.transform.setPosition(568,320);
		Genome2D.getInstance().root.addChild(node);

	}
}
}
