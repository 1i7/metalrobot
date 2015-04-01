// левое колесо
wheel_with_axis();
// правое колесо
//mirror([0, 0, -1]) wheel_with_axis();
// зажим для оси, блокирующий колесо
//axis_jam(3.2);

/** 
 * Колесо с отверстием под ось.
 */
module wheel_with_axis() {
  difference() {
    wheel();
    generic_axis();
    //motor1_axis();
    //motor2_axis();
  }
}

/** 
 * Колесо.
 */
module wheel() {

  // внешний обод
  difference() {
    // лысая резина
    //cylinder(h=20, r=25, $fn=100);
    // рельефный протектор
    translate([0, 0, 10]) {
      linear_extrude(height=10, twist=10) 
          import(file = "протектор.dxf");
      mirror([0, 0, -1]) 
        linear_extrude(height=10, twist=10) 
          import(file = "протектор.dxf");
    }

    translate([0, 0, -1])
      cylinder(h=22, r=20, $fn=100);
  }

  // внутренний вал
  cylinder(h=10, r=5, $fn=100);

  // спицы
  for(angle = [0, 72, 144, 216, 288]) {
    rotate(a=angle) rundle();
  }
}

/**
 * Спица.
 */
module rundle() {
  // простая спица 
  //translate([0, -1.5, 0]) cube([22, 3, 10]);
  
  // спица покрасивше
  translate([0, -1.5, 0]) 
    // вычтем из параллелепипеда часть цилиндра, 
    // чтобы получилось скругленное ребро
    difference() {
      cube([22, 3, 20]);
      translate([0, -1, 36]) rotate([270,0,0])
        cylinder(h=5, r=27, $fn=100);
    }
}

/**
 * Зажим для оси с отверстием под стягивающий винт.
 */
module axis_jam(screw_diam=3) {
  difference() {
    // внутренний вал
    cylinder(h=9, r=5, $fn=100);

    // ось
    generic_axis();
    //motor1_axis();
    //motor2_axis();

    // отверстие под винт
    translate([0, 0, 3]) rotate([60, 0, 0])
      // винт должен прорезать не только
      // внешнюю стенку, но и внутреннюю 
      // поверхность трубы
      translate([0, 0, -1])
      cylinder(h=10, r=screw_diam/2, $fn=100);
  }
}

/**
 * Просто круглая ось, по умолчанию диаметр 3мм.
 */
module generic_axis(length=22, radius=1.5) {
  translate([0,0,-1])
    cylinder(h=length, r=radius, $fn=20);
}

/** 
 * Ось для для мотора 1:
 * GM7 - Gear Motor 7 - Baby GM3 (прямой, белый)
 * www.robotshop.com/en/solarbotics-gm7-gear-motor-7.html
 *
 * Диаметр оси мотора 2мм, сделаем модель 1.5мм.
 */
module motor1_axis(length=22) {
  // 1.5мм диаметр
  generic_axis(length, 0.75);
}

/** 
 * Ось для для мотора 2:
 * Pololu 4.5V, 80rpm Right Angle (прямой, желтый)
 * www.robotshop.com/en/solarbotics-gm7-gear-motor-7.html
 *
 * Диаметр оси мотора 3мм, срез с одного бока 0.4мм.
 */
module motor2_axis(length=22) {
  // диаметр 3мм, срез с одного бока 0.4мм
  translate([0,0,-1])
  difference() {
    cylinder(h=length, r=1.5, $fn=20);
    // 1.5 мм "вниз" по y (совместить куб с цилиндром), 
    // 1.1 "вправо" по x (срезать справа 0.4мм: 1.5-0.4=1.1)
    translate([1.1, -1.5, 0]) 
      cube([2, 3, length]);
  }
}
