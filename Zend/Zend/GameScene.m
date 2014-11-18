//
//  GameScene.m
//  Zend
//
//  Created by Anton Yakimenko on 16.11.14.
//  Copyright (c) 2014 HardCode. All rights reserved.
//

#import "GameScene.h"
#define GREEN [NSColor colorWithCalibratedRed:0 green:1.0f blue:0 alpha:1.0f]
@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    pFactory = [[PlatformFactory alloc] init];
    cFactory = [[CharacterFactory alloc] init];
    plControl = [[PlayerControl alloc] init];
    world = [[SKNode alloc] init];
    self.physicsWorld.gravity = CGVectorMake(0, -8);
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"Background.png"];
    background.zPosition = -1;
    background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    background.size = self.size;
    [self addChild:world];
    [world addChild:background];
    
    
    Platform *platform = [pFactory createPlatformWithImageNamed:@"ground.png" atPosition:CGPointMake(400, 100)];
    
    /*Platform *dynPlatform = [pFactory createDynamicPlatformWithImageNamed:@"ground.png"
                                                            beginPosition:CGPointMake(800, 300)
                                                              endPosition:CGPointMake(200, 300) speed:1];
    [world addChild:[pFactory createDynamicPlatformWithImageNamed:@"ground.png"
                                                    beginPosition:CGPointMake(400, 500)
                                                      endPosition:CGPointMake(400, 100) speed:1]];*/
    [world addChild:platform];
    //[world addChild:dynPlatform];
    
    
    plControl.character = [cFactory spawnCharacter:@"Player" withType:@"Player"];
    [plControl.character setPosition:CGPointMake(300, 300)];
    [world addChild:plControl.character];
    
    /*SKSpriteNode *spriteA = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    SKSpriteNode *spriteB = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    spriteA.scale = 0.5;
    spriteB.scale = 0.5;
    spriteA.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:spriteA.frame.size];
    spriteB.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:spriteB.frame.size];
    spriteA.physicsBody.allowsRotation = NO;
    spriteB.physicsBody.allowsRotation = NO;
    int x = 500;
    spriteA.position = CGPointMake(x-300, 600);
    spriteB.position = CGPointMake(x+100, 600);
    spriteA.physicsBody.restitution = 0;
    spriteB.physicsBody.restitution = 0;

    //[world addChild:spriteA];
    //[world addChild:spriteB];

    spriteA.physicsBody.categoryBitMask = 2;
    spriteA.physicsBody.collisionBitMask = 3;
    spriteA.physicsBody.contactTestBitMask = 1;
    
    spriteB.physicsBody.categoryBitMask = 2;
    spriteB.physicsBody.collisionBitMask = 3;
    spriteB.physicsBody.contactTestBitMask = 1;*/
}

-(void)mouseDown:(NSEvent *)theEvent {
     /* Called when a mouse click occurs */

}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    NSArray *ns = [world children];
    for(int i=0; i<ns.count; ++i)
    {
        SKNode *node = [ns objectAtIndex:i];
        if([node.name isEqualToString:@"dynamicPlatform"])
        {
            DynamicPlatform *platform = (DynamicPlatform *)node;
            [platform update];
        }
        else if([node.name isEqualToString:@"Player"])
        {
            if(!(rand()%1007))
                node.physicsBody.velocity = CGVectorMake(0, 500);
        }
    }
}

@end
