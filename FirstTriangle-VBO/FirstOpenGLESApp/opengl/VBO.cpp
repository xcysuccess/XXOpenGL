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
    
    glGenBuffers(1, &vbo);
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, bufferSize, data, GL_STATIC_DRAW);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    return vbo;
}
