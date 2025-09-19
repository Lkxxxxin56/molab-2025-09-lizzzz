import Foundation

func load(_ file :String) -> String {
  let path = Bundle.main.path(forResource: file, ofType: nil)
  let str = try? String(contentsOfFile: path!, encoding: .utf8)
  return str!
}

// 1. Ask the user for their name
// print("What is your name?")
let name = "Lisa"

// 2. Ask for a favorite holiday
// print("What is your favorite holiday? (Christams/ Halloween / Thanksgiving)")
let holiday = "thanksgiving"

// 3. Match and print
switch holiday {
case "christmas":
    print(load("tree.txt"))
    print("Merry Christmas, \(name)!")
case "thanksgiving":
    print(load("turkey.txt"))
    print("Happy Thanksgiving, \(name)!")
case "halloween":
    print(load("pumpkin.txt"))
    print("Happy Halloween, \(name)!")
default:
    print("Hmm, I don't know that holiday… but Happy Holidays, \(name)!")
}

