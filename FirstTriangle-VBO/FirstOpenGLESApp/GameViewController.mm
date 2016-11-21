//
//  GameViewController.m
//  FirstOpenGLESApp
//
//  Created by tomxiang on 10/17/16.
//  Copyright © 2016 tomxiang. All rights reserved.
//

#import "GameViewController.h"
#import <OpenGLES/ES2/glext.h>
#import "VBO.hpp"
GLuint vbo;

@interface GameViewController () {
}
@property (strong, nonatomic) EAGLContext *context;

- (void)setupGL;
- (void)tearDownGL;

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
}

- (void)dealloc
{    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }

    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    float verticals[] = {
        0.0f,0.0f,-10.f,
        0.5f,0.0f,-10.f,
        0.0f,0.5f,-10.f
    };
    vbo = CreateVBOWithData(verticals, sizeof(float) * 9);
    NSLog(@"vbo name is: %u",vbo);
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    //update
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.1f, 0.4f, 0.7f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    //render
}

#pragma mark -  OpenGL ES 2 shader compilation

- (BOOL)loadShaders
{
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    return YES;
}

@end
