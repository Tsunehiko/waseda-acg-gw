import vertexShaderSource from './shader/vert.glsl'
import fragmentShaderSource from './shader/frag.glsl'

const cSize = {
    width: 400,
    height: 400,
} as const;
type cSize = typeof cSize[keyof typeof cSize];

const VERTEX_SIZE = 3; 

const main = () => {
    const canvas = document.createElement('canvas');
    canvas.width = cSize.width;
    canvas.height = cSize.height;
    document.body.appendChild(canvas);

    const mayBeContext = canvas.getContext('webgl2') as WebGL2RenderingContext;
    if (mayBeContext === null) {
        console.warn('could not get context');
        return
    }
    const gl: WebGL2RenderingContext = mayBeContext;
    const vertexShader = gl.createShader(gl.VERTEX_SHADER);
    gl.shaderSource(vertexShader, vertexShaderSource);
    gl.compileShader(vertexShader);

    const vertexShaderCompileStatus = gl.getShaderParameter(vertexShader, gl.COMPILE_STATUS);
    if (!vertexShaderCompileStatus) {
        const info = gl.getShaderInfoLog(vertexShader);
        console.warn(info);
        return
    }

    const fragmentShader = gl.createShader(gl.FRAGMENT_SHADER);
    gl.shaderSource(fragmentShader, fragmentShaderSource);
    gl.compileShader(fragmentShader);

    const fragmentShaderCompileStatus = gl.getShaderParameter(fragmentShader, gl.COMPILE_STATUS);
    if (!fragmentShaderCompileStatus) {
        const info = gl.getShaderInfoLog(fragmentShader);
        console.warn(info);
        return
    }

    const program = gl.createProgram();
    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);

    const linkStatus = gl.getProgramParameter(program, gl.LINK_STATUS);
    if (!linkStatus) {
        const info = gl.getProgramInfoLog(program);
        console.warn(info);
        return
    }
    gl.useProgram(program);

    // Clear screen
    gl.clearColor(0, 0, 0, 0);
    gl.clear(gl.COLOR_BUFFER_BIT);

    const vertexBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
    const vertices = new Float32Array([
        -1, 1, 0,
        1, 1, 0,
        -1, -1, 0,
        1, -1, 0
    ]);
    gl.bufferData(gl.ARRAY_BUFFER, vertices, gl.STATIC_DRAW);

    // Get and set vertex attribute
    const vertexAttribLocation = gl.getAttribLocation(program, 'vertexPosition');
    gl.enableVertexAttribArray(vertexAttribLocation);
    gl.vertexAttribPointer(vertexAttribLocation, VERTEX_SIZE, gl.FLOAT, false, 0, 0);

    gl.enable(gl.DEPTH_TEST);

    var resolution_loc = gl.getUniformLocation(program, 'resolution');
    var mouse_loc = gl.getUniformLocation(program, 'mouse');
    var time_loc = gl.getUniformLocation(program, 'time');
    var seed_loc = gl.getUniformLocation(program, 'seed');
    gl.uniform2f(resolution_loc, cSize.width, cSize.height);
    gl.uniform1ui(seed_loc, (Math.random() * 4294967296) >>> 0);

    function render(ms_since_page_loaded) {
        gl.uniform1f(time_loc, ms_since_page_loaded / 1000.0);
        // TODO: mouse

        gl.drawArrays(gl.TRIANGLE_STRIP, 0, vertices.length / VERTEX_SIZE);

        // Request animation again
        //requestAnimationFrame(render);
    }

    // First render which will request animation
    render(0);

    gl.flush();
}

window.onload = main;
