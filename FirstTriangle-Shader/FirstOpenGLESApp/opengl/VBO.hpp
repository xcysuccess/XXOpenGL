//
//  VBO.hpp
//  FirstOpenGLESApp
//
//  Created by tomxiang on 25/10/2016.
//  Copyright © 2016 tomxiang. All rights reserved.
//

#ifndef VBO_hpp
#define VBO_hpp

#include <stdio.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

//create empty GL_ARRAY_EMPTY init buffer size of bufferSize
GLuint CreateEmptyVBO(int bufferSize);

//create GL_ARRAY_EMPTY with data
GLuint CreateVBOWithData(void *data,int bufferSize);

//Compile Shader
GLuint CompileShader(GLenum shaderType,const char *code);

//Create Program
GLuint SimpleCreateProgram(const char *vsCode,const char *fsCode);

#endif /* VBO_hpp */
