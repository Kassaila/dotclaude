# Stack

Common use cases:
- **FE**: undo/redo history, back/forward navigation, modal/dialog stacking, nested dropdown menus, breadcrumb trail
- **BE**: expression parsing, bracket matching, DFS traversal, call stack simulation, recursive-to-iterative conversion, middleware chain unwinding

## mnemonist (preferred)

```javascript
import Stack from 'mnemonist/stack';

const s = new Stack();

s.push('a');
s.push('b');
s.peek(); // 'b'
s.pop();  // 'b'
s.size;   // 1
```

For fixed-capacity with typed array backing: `import FixedStack from 'mnemonist/fixed-stack'`.

## Manual fallback (Array wrapper)

```javascript
class Stack {
  #data = [];

  push(item) {
    this.#data.push(item);
  }

  pop() {
    return this.#data.pop();
  }

  peek() {
    return this.#data[this.#data.length - 1];
  }

  get size() {
    return this.#data.length;
  }

  isEmpty() {
    return this.#data.length === 0;
  }
}
```

Note: a plain `Array` already works as a stack (`push`/`pop`). A wrapper class is useful when you want to enforce LIFO-only access or need `peek()`/`isEmpty()` semantics.
