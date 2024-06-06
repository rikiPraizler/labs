use array::ArrayTrait;
use debug::PrintTrait;

fn main(){
    let x: u32 = sqrt(36);
}

fn rotateImage(imageData: Array<u32>, degrees: u32) {
    let width: u32 = sqrt(imageData.len());
    let height: u32 = width;
    let mut newArray = ArrayTrait::new();
    // let mut dict = felt252_dict_new::<u32>();
    newArray.append(1);
    newArray.append(2);
    let first_element = newArray.get(0).unwrap().unbox();

    // if degrees == 90 {
    //     let mut i: u32 = 0;
    //     loop {
    //         if i >= width { 
    //             break ();
    //         }
    //         let mut j: u32 = 0;
    //         loop {
    //             if j >= height { 
    //                 break ();
    //             }
    //             let newIndex = (j * width) + (width - i - 1);
                 
    //             dict.insert(newIndex,) = imageData[i * height + j];
    //             j = j + 1;
    //         };    
    //         i = i + 1;
    //     };
    // }

}
















fn sqrt(n: u32) -> u32 {

    let one = 1;
    let half = 1 / 2;
    
    let mut x = n / 2;

    let mut i: u32 = 0;
    loop {
        if i > 10 { 
            break ();
        }
        let x_new = (x + n / x) * half;
        x = x_new;
        i = i + 1;
    };
    x
}