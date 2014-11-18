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
    
    Platform *dynPlatform = [pFactory createDynamicPlatformWithImageNamed:@"ground.png"
                                                            beginPosition:CGPointMake(800, 300)
                                                              endPosition:CGPointMake(500, 300) speed:0.5];

    [world addChild:platform];
    [world addChild:dynPlatform];
    
    plControl.character = [cFactory createCharacter:PLAYER];
    [plControl.character setPosition:CGPointMake(300, 200)];
    [world addChild:plControl.character];
}

-(void)mouseDown:(NSEvent *)theEvent {
     /* Called when a mouse click occurs */
    CGPoint clickPosition = [theEvent locationInNode:world];
    Character *zombie;
    if(clickPosition.x > self.frame.size.width / 2) {
        zombie = [cFactory createCharacter:SZOMBIE];
    }
    else {
        zombie = [cFactory createCharacter:FZOMBIE];
    }
    zombie.position = clickPosition;
    [world addChild:zombie];
}

- (void)didSimulatePhysics {
    world.position = CGPointMake(-(plControl.character.position.x - self.size.width / 2), -(plControl.character.position.y - self.size.height / 2));
}

- (void) keyUp:(NSEvent *)theEvent
{
    NSString*   const   character   =   [theEvent charactersIgnoringModifiers];
    unichar     const   code        =   [character characterAtIndex:0];
    
    switch (code)
    {
        case NSUpArrowFunctionKey:
        {
            [plControl.character jump];
            break;
        }
        case NSLeftArrowFunctionKey:
        {
            plControl.leftKeyPressed = 0;
            if(plControl.rightKeyPressed)
            {
                [plControl setDirection: 1];
                [plControl.character run];
            }
            else
            {
                [plControl setDirection: 0];
                [plControl.character stop];
            }
            break;
        }
        case NSRightArrowFunctionKey:
        {
            plControl.rightKeyPressed = 0;
            if(plControl.leftKeyPressed)
            {
                [plControl setDirection: -1];
                [plControl.character run];
            }
            else
            {
                [plControl setDirection: 0];
                [plControl.character stop];
            }
            break;
        }
    }
}
- (void) keyDown:(NSEvent *)theEvent
{
    unichar const code = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
    
    switch (code)
    {
        case NSLeftArrowFunctionKey:
        {
            plControl.leftKeyPressed = 1;
            [plControl setDirection: -1];
            [plControl.character run];
            break;
        }
        case NSRightArrowFunctionKey:
        {
            plControl.rightKeyPressed = 1;
            [plControl setDirection:1];
            [plControl.character run];
            break;
        }
    }
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
        else if([node.name isEqualToString:@"Character"])
        {
            Character *character = (Character*)node;
            [character update];
        }
    }
}

@end
