//
//  ViewController.swift
//  VScale
//
//  Copyright © 2017 Glenn R. Golden. All rights reserved.
//

import UIKit
import SceneKit
import VScaleFramework

class ViewController: UIViewController, SCNSceneRendererDelegate {
	
	let LIGHT_LEVEL_MAX: Float = 2000
	let LIGHT_LEVEL_START: Float = 1000
	
	let AMBIENT_LEVEL_MAX: Float = 250
	let AMBIENT_LEVEL_START: Float = 100
	
	let ROOM_SIZE = SCNVector3(x: /*457.2*/Float(15).feet, y: Float(8).feet, z: Float(10).feet)
	let ROOM_POS = SCNVector3(x: 0, y: 0, z: 0)
	
	let CAMERA_POS = SCNVector3(x: Float(15).feet/2, y: Float(6).feet, z: Float(10).feet - Float(1).feet)
	let CAMERA_ROTATION = SCNVector4(x: 1 , y: 0, z: 0 , w: 0)
	
	let SYYCAM_POS = SCNVector3(x: Float(15).feet/2, y: Float(6).feet, z: Float(10).feet - Float(1).feet)
	let SYYCAM_ROTATION = SCNVector4(x: 1 , y: 0, z: 0 , w: 0)
	
	let AVATAR_POS = SCNVector3(x: 20, y: 0, z: Float(5).feet)
	let AVATAR_HEIGHT: Float = Float(5).feet
	let AVATAR_HEIGHT_MAX: Float = Float(7).feet
	
	let VELOCITY_MAX: Float = 50
	let VELOCITY_START: Float = 1
	
	var camera: SCNNode! = nil
	var ambientLight: SCNNode! = nil
	var room: Room! = nil
	var layout: Layout! = nil
	var avatar: Avatar! = nil
	var trains: [Train] = []
	
	var turnouts: [Line] = []
	var turnoutState: Int = 0
	
	var paused = true
	var time: TimeInterval? = nil
	//	var velocity: Float
	
	@IBOutlet weak var sceneView: SCNView!
	
	@IBOutlet weak var lightLevelSlider: UISlider!
	
	@IBOutlet weak var avatarHeightSlider: UISlider!
	@IBOutlet weak var avatarRotationSlider: UISlider!
	@IBOutlet weak var avatarLightSlider: UISlider!
	@IBOutlet weak var avatarXSlider: UISlider!
	@IBOutlet weak var avatarZSlider: UISlider!
	
	@IBOutlet weak var speedSlider: UISlider!
	
	@IBOutlet weak var cameraSelector: UISegmentedControl!
	
	@IBOutlet weak var distanceLabel: UILabel!
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		sceneView.scene = SCNScene()
		sceneView.delegate = self
		sceneView.backgroundColor = UIColor.black
		sceneView.isPlaying = true
		
		ambientLight = SCNNode()
		ambientLight.light = SCNLight()
		ambientLight.light!.type = SCNLight.LightType.ambient
		ambientLight.light!.color = UIColor.white
		ambientLight.light!.intensity = CGFloat(AMBIENT_LEVEL_START)
		sceneView.scene!.rootNode.addChildNode(ambientLight)
		
		camera = SCNNode()
		camera.camera = SCNCamera()
		camera.position = CAMERA_POS
		camera.rotation = CAMERA_ROTATION
		camera.camera!.zNear = 10
		camera.camera!.zFar = 400
		camera.camera!.xFov = 100
		sceneView.scene!.rootNode.addChildNode(camera)
		sceneView.pointOfView = camera
		
		setupFloorAndAxes(scene: sceneView.scene!)
		
		room = Room(dimensions: ROOM_SIZE, location : ROOM_POS, inNode: sceneView.scene!.rootNode)
		
		// build a layout
		layout = Layout(inNode: room.bench)
		
		plan1()
		
		// lay the track and roadbed (once the track plan is set)
		layout.layRailroad()
		
		// a train
		let train = Train()
			.add(EngineBlocky())
			.add(CabooseBlocky())
			.add(CabooseBlocky())
			.add(CabooseBlocky())
			.add(CabooseBlocky())
			.add(CabooseBlocky())
			.add(CabooseBlocky())
			.add(CabooseBlocky())
			.add(CabooseBlocky())
			.add(CabooseBlocky())
			.add(CabooseBlocky())
		train.velocity = VELOCITY_START
		trains.append(train)
		
		// place the train somwehere (by distance) on the layout's train path
		train.place(layout: layout, distance: 0/*, outbound: false*/)
		
		// set the initial turnouts
		train.setTurnout(turnout: turnouts[0], state: 0)
		train.setTurnout(turnout: turnouts[1], state: 0)
		train.setTurnout(turnout: turnouts[2], state: 0)
		turnoutState = 1
		
		avatar = Avatar(height: AVATAR_HEIGHT, location: AVATAR_POS, inNode: room.node)
		
		let tapRec = UITapGestureRecognizer()
		tapRec.addTarget(self, action: #selector(didTap))
		sceneView.addGestureRecognizer(tapRec)
		
		lightLevelSlider.value = LIGHT_LEVEL_START / LIGHT_LEVEL_MAX
		
		avatarHeightSlider.value = AVATAR_HEIGHT / AVATAR_HEIGHT_MAX
		avatarRotationSlider.value = 0.5
		avatarLightSlider.value = LIGHT_LEVEL_START / LIGHT_LEVEL_MAX
		avatarXSlider.value = avatar.node.position.x / ROOM_SIZE.x
		avatarZSlider.value = avatar.node.position.z / ROOM_SIZE.z
		speedSlider.value = VELOCITY_START / VELOCITY_MAX
	}
	
	func plan1()
	{
		let SEG_LEN: Float = 5 // 0.5
		let SEG_LEN_SHORT: Float = 1
		
		let path = layout.trackPlan
		
		let l1 = path.line(at: SCNVector3Make(60, 0, 30), angle: 0)
			.extend(length: 100)
		
		let t1 = path.turnout(inbound: Joint(line: l1, state: 0))
		
		let l4 = path.line(inbound: Joint(line: t1, state: 1))
			.extend(segmentLength: SEG_LEN_SHORT, arc: -Float.pi/6, radius: 30)
		//	.extend(length: 10).extend(diverging: -Float.pi/6, length: 10)
		
		let t3 = path.turnout(inbound: Joint(line: l4, state: 0))
		
		let l5 = path.line(inbound: Joint(line: t3, state: 0))
			.extend(length: 100)
			.extend(segmentLength: SEG_LEN_SHORT, arc: -Float.pi/6, radius: 30)
		//.extend(diverging: -Float.pi/6, length: 10)
		
		
		/* let l6 */_ = path.line(inbound: Joint(line: t3, state: 1))
			.extend(length: 6)
			.extend(segmentLength: SEG_LEN_SHORT, arc: -Float.pi/6, radius: 30)
			// .extend(length: 10).extend(diverging: -Float.pi/6, length: 10)
			.extend(length: 100)
		
		let t4 = path.turnin(state: 1, inbound: Joint(line: l5, state: 0))
		
		let l2 = path.line(inbound: Joint(line: t1, state: 0))
			.close(to: Joint(line: t4, state: 0))
		
		/* let l7 */_ = path.line(inbound: Joint(line: t4, state: 0))
			.extend(length: 50)
			.extend(segmentLength: SEG_LEN, arc: Float.pi/2, radius: 30)
			.extend(length: 20)
			.extend(segmentLength: SEG_LEN, arc: Float.pi/2, radius: 30)
			.extend(length: 50 + l1.length() + t1.length(state: 0) + l2.length() + t4.length(state: 1) + 10)
			.extend(segmentLength: SEG_LEN, arc: Float.pi/2, radius: 30)
			.extend(length: 20)
			.extend(segmentLength: SEG_LEN, arc: Float.pi/2, radius: 30)
			.close(to: Joint(line: l1, state: 0))
		
		turnouts.append(t1)
		turnouts.append(t3)
		turnouts.append(t4)
		
		_ = layout.addItem(Platform(), at: Placement(position: SCNVector3(x: 300, y: 0, z: 15)))
		_ = layout.addItem(Platform(), at: Placement(path: layout.trackPlan, distance: 0, offset: -6))
		_ = layout.addItem(Platform(), at: Placement(path: layout.trackPlan, distance: 0, offset: 6))
		_ = layout.addItem(Platform(), at: Placement(path: layout.trackPlan, state:[t1.id:1, t3.id: 0], distance: 192, offset: 6))
		
		for r in 0 ... 10
		{
			for c in 0 ... 10
			{
				_ = layout.addItem(Model(model: "monkey.scnassets/monkey"), at: Placement(position: SCNVector3(x: Float(330 + (r*3)), y: 0, z: Float(40 + (c*3)))))
			}
		}
	}
	
	func setupFloorAndAxes(scene : SCNScene)
	{
		//		let floor = SCNNode(geometry: SCNFloor())
		//		floor.physicsBody = SCNPhysicsBody.static()
		//		scene.rootNode.addChildNode(floor)
		
		scene.rootNode.addChildNode(addCylinder(radius: 0.1, height: 2000,
		                                        position: SCNVector3(x: 0.0, y: 0.0, z: 0.0),
		                                        rotation: SCNVector4(x: 0.0, y: 0.0, z: 0.0, w: 0.0),
		                                        color: UIColor.green))
		scene.rootNode.addChildNode(addCylinder(radius: 0.1, height: 2000,
		                                        position: SCNVector3(x: 0.0, y: 0.0, z: 0.0),
		                                        rotation: SCNVector4(x: 0.0, y: 0.0, z: 1.0, w: Float.pi/2),
		                                        color: UIColor.red))
		scene.rootNode.addChildNode(addCylinder(radius: 0.1, height: 2000,
		                                        position: SCNVector3(x: 0.0, y: 0.0, z: 0.0),
		                                        rotation: SCNVector4(x: 1.0, y: 0.0, z: 0.0, w: Float.pi/2),
		                                        color: UIColor.blue))
	}
	
	func addCylinder(radius: CGFloat, height: CGFloat, position: SCNVector3, rotation: SCNVector4, color: UIColor) -> SCNNode
	{
		let geometry = SCNCylinder(radius: radius, height: height)
		let node = SCNNode(geometry: geometry)
		node.position = position;
		node.rotation = rotation
		geometry.firstMaterial?.diffuse.contents = color
		
		return node
	}
	
	func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval)
	{
		DispatchQueue.main.async(execute: {self.step(time: time)})
	}
	
	func step(time: TimeInterval)
	{
		if !self.paused
		{
			if let t = self.time
			{
				let deltaT : Float = Float(time - t)
				for train in trains
				{
					train.advance(time: deltaT)
				}
				
				let distance: Float = (trains[0].first?.pathDistance)!
				let msg =  String(format: "%.01f", distance)
				distanceLabel.text = "\(msg)"
			}
		}
		
		self.time = time
	}
	
	func didTap(_ sender: UITapGestureRecognizer)
	{
		paused = !paused
		
		if (paused)
		{
			print("paused")
		}
		else
		{
			print("running")
		}
	}
	
	@IBAction func lightAction(_ sender: UISlider)
	{
		// adjust the 2 room lights and ambient light
		if let r = self.room
		{
			r.setLightLevel(lumens: sender.value * LIGHT_LEVEL_MAX)
			r.setMainLightLevel(lumens: sender.value * LIGHT_LEVEL_MAX)
		}
		ambientLight.light!.intensity = CGFloat(sender.value * AMBIENT_LEVEL_MAX)
	}
	
	@IBAction func avatarHeightAction(_ sender: UISlider)
	{
		avatar.setHeight(sender.value * AVATAR_HEIGHT_MAX)
	}
	
	@IBAction func avatarRotationAction(_ sender: UISlider)
	{
		avatar.setRotation((sender.value * 2 * Float.pi) - Float.pi)
	}
	
	@IBAction func avatarLightAction(_ sender: UISlider)
	{
		avatar.setLightLevel(lumens: sender.value * LIGHT_LEVEL_MAX)
	}
	
	@IBAction func avatarXAction(_ sender: UISlider) {
		avatar.setPositionX(sender.value * ROOM_SIZE.x)
	}
	
	@IBAction func avatarZAction(_ sender: UISlider) {
		avatar.setPositionZ(sender.value * ROOM_SIZE.z)
	}
	
	@IBAction func cameraSelectAction(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex
		{
		case 0:
			sceneView.pointOfView = camera
			
		case 1:
			sceneView.pointOfView = room.camera
			
		case 2:
			sceneView.pointOfView = avatar.camera
			
		default:
			let t = min(sender.selectedSegmentIndex-2, trains.count-1)
			if let camera = trains[t].first?.camera
			{
				sceneView.pointOfView = camera
			}
		}
	}
	
	@IBAction func speedSliderAction(_ sender: UISlider)
	{
		for train in trains
		{
			train.velocity = sender.value * VELOCITY_MAX
		}
	}
	
	@IBAction func resetAction(_ sender: UIButton)
	{
		// pause, set initial position for trains
		paused = true
		for train in trains
		{
			train.place(layout: layout, distance: 0)
			
			switch turnoutState
			{
			case 0:
				train.setTurnout(turnout: turnouts[0], state: 0)
				train.setTurnout(turnout: turnouts[1], state: 0)
				//train.setTurnout(turnout: turnouts[2], state: 0)
				turnoutState = 1
			case 1:
				train.setTurnout(turnout: turnouts[0], state: 1)
				train.setTurnout(turnout: turnouts[1], state: 0)
				//train.setTurnout(turnout: turnouts[2], state: 1)
				turnoutState = 2
			case 2:
				train.setTurnout(turnout: turnouts[0], state: 1)
				train.setTurnout(turnout: turnouts[1], state: 1)
				//train.setTurnout(turnout: turnouts[2], state: 0)
				turnoutState = 0
			default:
				turnoutState = 0
			}
		}
	}
	
	override var shouldAutorotate : Bool
	{
		return true
	}
	
	override var supportedInterfaceOrientations : UIInterfaceOrientationMask
	{
		return UIInterfaceOrientationMask.landscape
	}
	
	override var prefersStatusBarHidden: Bool
	{
		return true
	}
}

