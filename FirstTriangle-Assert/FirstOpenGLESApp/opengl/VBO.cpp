//
//  VBO.cpp
//  FirstOpenGLESApp
//
//  Created by tomxiang on 25/10/2016.
//  Copyright © 2016 tomxiang. All rights reserved.
//

#include "VBO.hpp"

GLuint CreateEmptyVBO(int bufferSize){
    GLuint vbo;
    
    glGenBuffers(1, &vbo);
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, bufferSize, nullptr, GL_STATIC_DRAW);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    return vbo;
}

GLuint CreateVBOWithData(void *data,int bufferSize){
    GLuint vbo;
    //1.创建定点缓冲区
    glGenBuffers(1, &vbo);
    //2.制定vbo类型
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    //3.给vbo赋值
    glBufferData(GL_ARRAY_BUFFER, bufferSize, data, GL_STATIC_DRAW);
    //4.回复初始状态
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    return vbo;
}

GLuint CompileShader(GLenum shaderType,const char *code){
    GLuint shader = glCreateShader(shaderType);
    glShaderSource(shader, 1, &code, nullptr);
    glCompileShader(shader);
    
    GLint compileResult = GL_TRUE;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compileResult);
    if(compileResult == GL_FALSE){
        printf("compile shader fail with shader code %s\n",code);
        char szLogBuffer[1024] = {0};
        GLsizei logLen = 0;
        glGetShaderInfoLog(shader, 1024, &logLen, szLogBuffer);
        printf("%s\n",szLogBuffer);
        glDeleteShader(shader);
        return 0;
    }
    
    return shader;
}

GLuint SimpleCreateProgram(const char *vsCode,const char *fsCode){
    
    GLuint vsShader = CompileShader(GL_VERTEX_SHADER, vsCode);
    GLuint fsShader = CompileShader(GL_FRAGMENT_SHADER, fsCode);
    
    GLuint program = glCreateProgram();
    glAttachShader(program, vsShader);
    glAttachShader(program, fsShader);
    glLinkProgram(program);
    
    glDetachShader(program, vsShader);
    glDetachShader(program, fsShader);
    glDeleteShader(vsShader);
    glDeleteShader(fsShader);
    
    GLint linkResult = GL_TRUE;
    glGetProgramiv(program, GL_LINK_STATUS, &linkResult);
    if(linkResult == GL_FALSE){
        printf("link program fail vs : %s \n fs : %s\n",vsCode,fsCode);
        char szLogBuffer[1024] = {0};
        GLsizei logLen = 0;
        glGetProgramInfoLog(program, 1024, &logLen, szLogBuffer);
        printf("%s\n",szLogBuffer);
        glDeleteShader(program);
        return 0;
    }
    return program;
}
