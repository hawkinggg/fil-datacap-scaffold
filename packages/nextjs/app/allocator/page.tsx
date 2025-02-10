"use client";

import { useState } from "react";
import type { NextPage } from "next";
import { IntegerInput } from "~~/components/scaffold-eth";

const Allocator: NextPage = () => {
  const [txValue, setTxValue] = useState<string>("");

  return (
    <div className="flex items-center flex-col flex-grow pt-10">
      Allocator
      <IntegerInput
        value={txValue}
        onChange={updatedTxValue => {
          setTxValue(updatedTxValue);
        }}
        placeholder="issue number"
      />
    </div>
  );
};

export default Allocator;
