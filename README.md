# AutocompleteText
This library want to provide a simple way to create dropdown that will be placed under the textfields.

![Recordit GIF](https://recordit.co/4R9ojkN4PE.gif)

## Possible settings

- Case sensitive and insensitive match
- Shadow
- Border and separator
- Corner rounding
- Background
- Minimum amount of characters to trigger the dropdown
- Font
- Levenshtein distance for the match

## Example 

```swift
import UIKit
import AutocompleteText

class ViewController: UIViewController {

    private var autocompleteController: AutocompleteController!

    @IBOutlet weak var autocompleteTextField: AutocompleteTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        autocompleteController = AutocompleteController(autocompleteTextField: autocompleteTextField)
        
        autocompleteController.delegate = self
        autocompleteController.minimumAmountOfCharacter = 0
        autocompleteController.values = ExampleData.superheroes
        autocompleteController.cornerRadius = 8
        autocompleteController.shadow = .bottomRight
    }
  
}

extension ViewController: AutocompleteControllerDelegate {
    func autocompleteControllerShouldAutocomplete(_ autocompleteController: AutocompleteController) -> Bool {
        return true
    }
}
```

## How to create an AutocompleteTextField

Your TextField to be used by the AutocompleteController must conform to the Autocompletable protocol

```swift
class AutocompleteTextField: UITextField, Autocompletable {}
```

## Delegate

The AutocompleteController exposes this 4 delegates

> The mandatory one

```swift
func autocompleteControllerShouldAutocomplete(_ autocompleteController: AutocompleteController) -> Bool
```

> The others

```swift
func autocompleteControllerDismissed(_ autocompleteController: AutocompleteController)
func autocompleteController(_ autocompleteController: AutocompleteController, didTapIndex index: Int, textAtIndex text: String)
func autocompleteController(_ autocompleteController: AutocompleteController, didFindMatch match: Bool)
```

When the user tap on a hint, the delegate return 2 values:

- The absolute index, relative to the list of values that was given
- The string that was tapped

So you can have a choice on what you will use for your specfic case.

## Levenshtein distance

The levenshtein distance is defined as the minimum number of modification to turn the string A into the string B.

In the AutocompleteController you can modify this value (default to 0) to set the tolerance of the match.

Levenshtein distance equal to 0

![Recordit GIF](https://recordit.co/1bPnbYt9z2.gif)

Levenshtein distance equal to 1

![Recordit GIF](https://recordit.co/sa9xGHVoo0.gif)

Levenshtein distance equal to 2

![Recordit GIF](https://recordit.co/9Le7GGjLRE.gif)

Clearly, after a certain point if the distance value became too large the match start to lose it's sense,
but if it's used wisely (with a small value like 1 or 2), can be useful if the user make a small typo.







