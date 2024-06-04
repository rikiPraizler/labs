fn main() {
    let immutable_var: felt252 = 17;

    let mut mutable_var: felt252 = immutable_var;
    mutable_var = 45;
    assert(mutable_var != immutable_var, 'mutable equals immytable');

}

#[test]
fn test_main() {
    main();
}