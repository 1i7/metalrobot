$fn=100;

//print_error = 0.0;
print_error = 0.2;

motor_fix(print_error=print_error);
//axis_fix(print_error=print_error);
//frame_fix(print_error=print_error);

/**
 * Крепление для мотора-редуктора popolu.
 */
module motor_fix(print_error=0) {
  // главный блок с шестеренками
  mlenx_1 = 20;
  // защелка
  mlenx_2 = 25;
  // рамка
  mlenx_3 = 25;
  // блок с мотором
  mlenx_4 = 23;
    
  // главный блок с шестеренками
  mleny_1 = 14;
  // защелка
  mleny_2 = 7;
  // рамка
  mleny_3 = 14;
  // блок с мотором
  mleny_4 = 12;
  
  // защелка
  mlenz_2 = 2;
  // рамка
  mlenz_3 = 3;
    
  // всё центрируем по x и по y
  difference() {
    union() {
      // по ширине рамки + стенки 2мм
      translate([-(mlenx_3+4)/2, -mleny_1/2-2, 0]) cube([mlenx_3+4, mleny_1+2, 28]);
      // крепления на корпус
      linear_extrude(height=2) import(file="крепление-мотор-43d.dxf");
    }
    // главный блок с шестеренками
    translate([-mlenx_1/2-print_error, -mleny_1/2-print_error, -0.1]) 
      cube([mlenx_1+print_error*2, mleny_1+print_error*2+0.1, 28+0.2]);
    // защелки
    translate([-mlenx_2/2-print_error, -mleny_2/2-print_error, -0.1]) 
      cube([mlenx_2+print_error*2, mleny_2+print_error*2, mlenz_3+mlenz_2]);
    // рамка вокруг мотора
    translate([-mlenx_3/2-print_error, -mleny_3/2-print_error, -0.1]) 
      cube([mlenx_3+print_error*2, mleny_3+print_error*2+0.1, mlenz_3]);
    
    // канавка по внутренней поверхности задней стенки
    translate([-6/2, -mleny_1/2-print_error-1, -0.1])
      cube([6, 1+0.1, 30+0.2]);
    
    // рассверлить отверстия под винты с учетом print_error
    // справа
    translate([23+2, 0+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
    translate([23+2, -10+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
    translate([23+2, -20+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
    translate([13+2, -20+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
    translate([3+2, -20+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
    // слева
    translate([-(23+2), 0+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
    translate([-(23+2), -10+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
    translate([-(23+2), -20+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
    translate([-(13+2), -20+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
    translate([-(3+2), -20+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
  }
}

/**
 * Крепление для оси
 */
module axis_fix(print_error=0) {
  rod_fix_lenx = 20;
  rod_fix_leny = 20;
  difference() {
    linear_extrude(height=3) import(file="крепление-ось-43d.dxf");
    
    // круглая ось
    translate([-0.1, rod_fix_leny/2, 1]) rotate([0, 90, 0]) 
      cylinder(r=1+print_error, h=rod_fix_lenx+0.2, $fn=100);
    // прямоугольный выход
    translate([-0.1, rod_fix_leny/2-1-print_error, -0.1]) 
      cube([rod_fix_lenx+0.2, 2+print_error*2, 1+0.1]);
      
    // рассверлить отверстия под винты с учетом print_error
    translate([3+2, 3+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
    translate([3+4+6+2, 3+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
    translate([3+2, 3+4+6+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
    translate([3+4+6+2, 3+4+6+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
  }
}

/**
 * Вертикальные крепления рамы корпуса.
 */
module frame_fix(print_error=0) {
  difference() {
    union() {
      cube([30, 2, 28]);
      cube([30, 3+4+3, 2]);
      translate([0, 0, 28-2])
        cube([30, 3+4+3, 2]);
    }
    
    // вертикальные дырки для винтов
    translate([3+2, 3+2, -0.1])
      cylinder(h=28+0.2, r=2+print_error);
    translate([3+2+10, 3+2, -0.1])
      cylinder(h=28+0.2, r=2+print_error);
    translate([3+2+10+10, 3+2, -0.1])
      cylinder(h=28+0.2, r=2+print_error);
    
    // вертикальные канавки в стенках для шляпок
    translate([3+2, 3+2, 2])
      cylinder(h=28-4, r=4+print_error);
    translate([3+2+10, 3+2, 2])
      cylinder(h=28-4, r=4+print_error);
    translate([3+2+10+10, 3+2, 2])
      cylinder(h=28-4, r=4+print_error);
    
    // горизонтальные дырки в стенах для винтов просто так
    // нижний ряд
    translate([3+2, -0.1, 2+3+2])
      rotate([-90,0,0]) cylinder(h=2+0.2, r=2+print_error);
    translate([3+2+10, -0.1, 2+3+2])
      rotate([-90,0,0]) cylinder(h=2+0.2, r=2+print_error);
    translate([3+2+10+10, -0.1, 2+3+2])
      rotate([-90,0,0]) cylinder(h=2+0.2, r=2+print_error);
    // второй снизу ряд
    translate([3+2, -0.1, 2+3+2+10])
      rotate([-90,0,0]) cylinder(h=2+0.2, r=2+print_error);
    translate([3+2+10, -0.1, 2+3+2+10])
      rotate([-90,0,0]) cylinder(h=2+0.2, r=2+print_error);
    translate([3+2+10+10, -0.1, 2+3+2+10])
      rotate([-90,0,0]) cylinder(h=2+0.2, r=2+print_error);
  }
}
