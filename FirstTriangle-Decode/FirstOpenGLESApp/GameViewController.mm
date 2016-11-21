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
#import "Glm/glm.hpp"
#import "Glm/ext.hpp"

GLuint vbo;
GLuint program;
GLuint positionLocation,MLocation,VLocation,PLocation;

glm::mat4 identityMatrix;   //投影矩阵 3D->2D
glm::mat4 projectionMatrix; //

@interface GameViewController () {
}
@property (strong, nonatomic) EAGLContext *context;

- (void)setupGL;
- (void)tearDownGL;

@end

@implementation GameViewController

-(char*) loadInternalAssert:(const char*) path{
    char *assetContent = nullptr;
    NSString *nsPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:path] ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:nsPath];
    assetContent = new char[[data length] + 1];
    memcpy(assetContent, [data bytes], [data length]);
    assetContent[[data length]]='\0';
    return assetContent;
}

//解码bmp
-(unsigned char*) deCodeBMP:(char*) bmpData width:(int*) width height:(int*) height{
    unsigned char*imgData=nullptr;
    if (0x4D42==*((unsigned short*)bmpData))
    {
        int pixelDataOffset=*((unsigned short*)(bmpData+10));
        width =((int*)(bmpData+18));
        height =((int*)(bmpData+22));
        imgData=(unsigned char*)(bmpData+pixelDataOffset);
        //BGR -> RGB
        for (int i=0; i< (*width)*(*height)*3; i+=3) {
            std::swap(imgData[i],imgData[i+2]);
        }
    }
    return imgData;

}

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
    //1.创建数据 init geometry data-> pass to gpu
    float verticals[] = {
        0.0f,0.0f,-2.f,
        0.5f,0.0f,-2.f,
        0.0f,0.5f,-2.f
    };
    vbo = CreateVBOWithData(verticals, sizeof(float) * 9);
    NSLog(@"vbo name is: %u",vbo);
    
    //init gpu program => render scene program
    char *vsCode = [self loadInternalAssert:"Data/Shader/simple.vs"];
    char *fsCode = [self loadInternalAssert:"Data/Shader/simple.fs"];
    
    program = SimpleCreateProgram(vsCode, fsCode);
    
    positionLocation = glGetAttribLocation(program, "position");
    MLocation = glGetUniformLocation(program, "M");
    VLocation = glGetUniformLocation(program, "V");
    PLocation = glGetUniformLocation(program, "P");
    //三维物体3D->2D
    CGFloat aspectF = [UIScreen mainScreen].bounds.size.width/[UIScreen mainScreen].bounds.size.height;
    projectionMatrix = glm::perspective(50.f, 640.f/960.f, 0.1f, 1000.f);
    
    char*bmpData = [self loadInternalAssert:"Data/wood.bmp"];
    int width = 0,height = 0;
    unsigned char*imageData = [self deCodeBMP:bmpData width:&width height:&height];
    NSLog(@"bmp width %d height %d",width,height);
    delete bmpData;
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
    glClearColor(0.1f, 0.3f, 0.7f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //1.render
    glUseProgram(program);
    
    //2.set uniform value
    glUniformMatrix4fv(MLocation, 1, GL_FALSE, glm::value_ptr(identityMatrix));
    glUniformMatrix4fv(VLocation, 1, GL_FALSE, glm::value_ptr(identityMatrix));
    glUniformMatrix4fv(PLocation, 1, GL_FALSE, glm::value_ptr(projectionMatrix));
    
    //3.set vbo
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    //绑定属性组
    glEnableVertexAttribArray(positionLocation);
    glVertexAttribPointer(positionLocation, 3, GL_FLOAT, GL_FALSE, sizeof(float)*3, 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
    glUseProgram(0);
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
