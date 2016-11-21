//
//  Shader.fsh
//  FirstOpenGLESApp
//
//  Created by tomxiang on 10/17/16.
//  Copyright © 2016 tomxiang. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
