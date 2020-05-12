import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.geom.mesh.subdiv.*;
import toxi.geom.mesh2d.*;
import toxi.math.*;
import toxi.math.conversion.*;
import toxi.math.noise.*;
import toxi.math.waves.*;
import toxi.util.*;
import toxi.util.datatypes.*;
import toxi.util.events.*;

import toxi.physics.*;
import toxi.physics.behaviors.*;
import toxi.physics.constraints.*;

// wariables needed for the simultion:

  float w = 15;
  int ppl = 6;
  
  // points that are fixed on the letter 
  float[][] fixed_points_f;
  float[][] fixed_points_i;
  float[][] fixed_points_s;
  float[][] fixed_points_h;
  float[][] fixed_points_n;
  float[][] fixed_points_e;
  float[][] fixed_points_t;
  
  

  // number of points of the net of each letter: col*row
  int cols = 25;
  int rows = 25;

  // depth of the simulation
  int h = 0;

  // list of total particles for each letter 
  Particle[][] particles_f = new Particle[cols][rows];
  Particle[][] particles_i = new Particle[cols][rows];
  Particle[][] particles_s = new Particle[cols][rows];
  Particle[][] particles_h = new Particle[cols][rows];
  Particle[][] particles_n = new Particle[cols][rows];
  Particle[][] particles_e = new Particle[cols][rows];
  Particle[][] particles_t = new Particle[cols][rows];
  

  
  ArrayList<Spring> springs;

  VerletPhysics physics;

//-------------------------------setup the simulation --------------------------------------------

  void setup() {
   
    // setup the size of the window 
    size(800, 800, P3D); 
    
    // loading the points for each letter
    fixed_points_f  = load_csv("f.csv");
    fixed_points_i  = load_csv("i.csv");
    fixed_points_s  = load_csv("s.csv");
    fixed_points_h  = load_csv("h.csv");
    fixed_points_n  = load_csv("n.csv");
    fixed_points_e  = load_csv("e.csv");
    fixed_points_t  = load_csv("t.csv");
    

    // translating to the letter to the right position
    translate_to(0 , -60, fixed_points_f);
    translate_to(150 , -60, fixed_points_i);
    translate_to(200 , -60, fixed_points_s);
    translate_to(330 , -60, fixed_points_h);
    translate_to(460 , -60, fixed_points_n);
    translate_to(600 , -60, fixed_points_e);
    translate_to(750 , -60, fixed_points_t);

    // setup the physical prop. of the simulation 
    springs = new ArrayList<Spring>();
    physics = new VerletPhysics();
    Vec3D gravity = new Vec3D(0, 0.2, 0);
    GravityBehavior gb = new GravityBehavior(gravity);
    physics.addBehavior(gb);

    
    // select the first point on each letter
    float x_f = fixed_points_f[0][0];
    float x_i = fixed_points_i[0][0];
    float x_s = fixed_points_s[0][0];
    float x_h = fixed_points_h[0][0];
    float x_n = fixed_points_n[0][0];
    float x_e = fixed_points_e[0][0];
    float x_t = fixed_points_t[0][0];
    
  
    // do the setup of each letter and add them to the physical simulation
    // F:
    setup_part(fixed_points_f, x_f, particles_f);
    lock_particles(ppl,ppl,fixed_points_f, particles_f);
    add_spring(particles_f);
    // I:
    setup_part(fixed_points_i, x_i, particles_i);
    lock_particles(ppl,ppl,fixed_points_i, particles_i);
    add_spring(particles_i);
    // S:
    setup_part(fixed_points_s, x_s, particles_s);
    lock_particles(ppl,ppl,fixed_points_s, particles_s);
    add_spring(particles_s);
    // H:
    setup_part(fixed_points_h, x_h, particles_h);
    lock_particles(ppl,ppl,fixed_points_h, particles_h);
    add_spring(particles_h);
    // N:
    setup_part(fixed_points_n, x_n, particles_n);
    lock_particles(ppl,ppl,fixed_points_n, particles_n);
    add_spring(particles_n);
    // E:
    setup_part(fixed_points_e, x_e, particles_e);
    lock_particles(ppl,ppl,fixed_points_e, particles_e);
    add_spring(particles_e);
    // H:
    setup_part(fixed_points_t, x_t, particles_t);
    lock_particles(ppl,ppl,fixed_points_t, particles_t);
    add_spring(particles_t);
     
  }

  // define angle of rotation 
  float a = -0.01;

//----------------------------start the animation-------------------------------------------
  void draw() {
    
 
         

    // clear background 
    background(0);
  
    // move to the current drawing position 
    //translate(0, 0);
        camera(width/2., -mouseY, mouseX,
           width/2., 0, 0,
           0, 1, 0);
        textSize(40);
    fill(255);
    line(0, 0, 0, 200, 0, 0);
    text("x", 200, 0, 0); 
    
    line(0, 0, 0, 0, 200, 0);
    text("y", 0, 200, 0); 
    
    line(0, 0, 0, 0, 0, 200);
    text("z", 0, 0, 200); 
    //translate(0.5*width, 0.5*height);
    //rotateY(a);
    //a += 0.01;
    
    rotateX(0.03);
    
    // update the phisical simulation 
    physics.update();

    // display the particles
    
    /*
    for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
       particles_s[i][j].display();
       }
    }
    */

    // display the springs
    for (Spring s : springs) {
      s.display();
    }
    
    // draw each letter:
    draw_letter(fixed_points_f);
    draw_letter(fixed_points_i);
    draw_letter(fixed_points_s);
    draw_letter(fixed_points_h);
    draw_letter(fixed_points_n);
    draw_letter(fixed_points_e);
    draw_letter(fixed_points_t);
    

  }

//------------------------local methods--------------------------------------------------------

void draw_letter(float [][] fixed_points){
  for( int i = 0; i < fixed_points.length; i ++){
    pushMatrix();
    //translate(fixed_points[i][0], 100, fixed_points[i][1]);
    //sphere(1);
    stroke(255);
    strokeWeight(2);
    if(i != fixed_points.length-1){
    line(fixed_points[i][0],h,fixed_points[i][1],fixed_points[i+1][0],h,fixed_points[i+1][1]);
    }
    else{
    line(fixed_points[i][0],h,fixed_points[i][1],fixed_points[0][0],h,fixed_points[0][1]);
    }
    popMatrix();   
  }
  
}

float [][] select_FP(int n, float [][] fixed_points){
  
  float [][] FP = new float [n][2];
  int step = fixed_points.length/n;
  int pcount = 0;
  for( int i = 0; i < n; i ++){
     FP[i] = fixed_points[pcount];
     //println(FP[fpcount][0] + " , " + FP[fpcount][1]);
     pcount += step;
  }
  return FP;
  
}

void lock_particles(int nx, int ny, float [][]fixed_points, Particle[][] part_list){
  
  int n = 2*nx + 2*ny;
  
  float [][] fp = select_FP(n,fixed_points);
    
  int stepx = cols/nx;
  println("stepx: " + stepx);
  
  
  int stepy = rows/ny;
    println("stepy: " + stepy);
    
    println("length: " + fp.length);
  
  int fp_count = 0;
  
  int x = 0;
  int y = 0;
  int delta = 0;

    
   for(x = 0; x < cols-stepx; x += stepx){
       y = rows-1;
       println("side0: " + fp_count);
      
      Particle p = new Particle(fp[fp_count][0],h ,fp[fp_count][1]);
      part_list[x][y] = p; 
      physics.addParticle(p);
      part_list[x][y].lock();
      fp_count ++;
    }
    fp_count --;

    for(y = rows-1; y >= 0+stepy; y -= stepy){
      println("side1: " + fp_count);
      x = cols-1;
      Particle p = new Particle(fp[fp_count][0],h,fp[fp_count][1]);
      part_list[x][y] = p; 
      physics.addParticle(p);
      part_list[x][y].lock();
      fp_count ++;
    }
    fp_count --;
    for(x = cols - 1; x >= 0+stepx; x -= stepx){
      println("side2: " + fp_count);
      y = 0;
      Particle p = new Particle(fp[fp_count][0],h ,fp[fp_count][1]);
      part_list[x][y] = p; 
      physics.addParticle(p);
      part_list[x][y].lock();
      fp_count ++;
    }
    fp_count --;
    for(y = 0 ; y < rows-stepy; y += stepy){
      println("side3: " + fp_count);
      x = 0;
      Particle p = new Particle(fp[fp_count][0],h ,fp[fp_count][1]);
      part_list[x][y] = p; 
      physics.addParticle(p);
      part_list[x][y].lock();
      fp_count ++;
    }
}

void save_CSV(float[][] plist, String file_name){
  Table table = new Table();
  table.addColumn("x");
  table.addColumn("y");
  for(int i = 0; i < plist.length; i++){
    TableRow newRow = table.addRow();
    newRow.setFloat("x", plist[i][0] );
    newRow.setFloat("y", plist[i][1] );
  }
  saveTable(table, file_name);
}

float [][] load_csv(String filename){

  Table table = loadTable(filename, "header");
  float[][] letter = new float [table.getRowCount()][2];
  int i = 0;
  for (TableRow row : table.rows()){
    letter[i][0] = row.getFloat("x");
    letter[i][1] = row.getFloat("y");
    i++;
  }
  return letter;
  
}

void setup_part(float[][] fixed_points, float x,Particle[][] part_list){
    for (int i = 0; i < cols; i++) {
      float z = fixed_points[0][1];
        for (int j = 0; j < rows; j++) {
      
          Particle p = new Particle(x,h,z);
          part_list[i][j] = p;
          physics.addParticle(p);
          z = z - w;
        }
      x = x + w;
    }
  }

void add_spring(Particle[][] p){
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      Particle a = p[i][j];
      if (i != cols-1) {
        Particle b1 = p[i+1][j];
        Spring s1 = new Spring(a, b1);
        springs.add(s1);
        physics.addSpring(s1);
      }
      if (j != rows-1) {
        Particle b2 = p[i][j+1];
        Spring s2 = new Spring(a, b2);
        springs.add(s2);
        physics.addSpring(s2);
      }
    }
  }
}

void translate_to(float x , float y, float [][] fixed_points){
    for( int i = 0; i < fixed_points.length; i ++){
      fixed_points[i][0] = fixed_points[i][0] + x;
      fixed_points[i][1] = fixed_points[i][1] + y;  
    }

}
