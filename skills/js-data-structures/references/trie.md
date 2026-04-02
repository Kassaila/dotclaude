# Trie (Prefix Tree)

Common use cases:

- **FE**: autocomplete, command palette, tag/emoji search, search suggestions, dictionary lookup
- **BE**: URL pattern routing, IP prefix matching, CLI argument parsing, feature flag prefix
  matching, word filtering

## mnemonist (preferred)

```javascript
import Trie from 'mnemonist/trie';

const trie = Trie.from(['react', 'redux', 'remix', 'recoil', 'relay']);

/**
 * has('react') → true
 * find('re') → ['react', 'redux', 'remix', 'recoil', 'relay']
 * find('rem') → ['remix']
 */
trie.has('react');
trie.find('re');
trie.find('rem');
trie.delete('remix');
```

For key-value mapping (e.g. route → handler): `import TrieMap from 'mnemonist/trie-map'`.

## Manual fallback (Map-based trie)

```javascript
class TrieNode {
  #children = new Map();
  #isEnd = false;

  get children() {
    return this.#children;
  }

  get isEnd() {
    return this.#isEnd;
  }

  set isEnd(value) {
    this.#isEnd = value;
  }
}

class Trie {
  #root = new TrieNode();

  insert(word) {
    let node = this.#root;

    for (const ch of word) {
      if (!node.children.has(ch)) {
        node.children.set(ch, new TrieNode());
      }

      node = node.children.get(ch);
    }

    node.isEnd = true;
  }

  has(word) {
    const node = this.#traverse(word);

    return node !== null && node.isEnd;
  }

  startsWith(prefix) {
    return this.#traverse(prefix) !== null;
  }

  complete(prefix, limit = 10) {
    const node = this.#traverse(prefix);

    if (!node) {
      return [];
    }

    const results = [];

    this.#collect(node, prefix, results, limit);

    return results;
  }

  #traverse(str) {
    let node = this.#root;

    for (const ch of str) {
      node = node.children.get(ch);

      if (!node) {
        return null;
      }
    }

    return node;
  }

  #collect(node, prefix, results, limit) {
    if (results.length >= limit) {
      return;
    }

    if (node.isEnd) {
      results.push(prefix);
    }

    for (const [ch, child] of node.children) {
      this.#collect(child, prefix + ch, results, limit);
    }
  }
}
```
