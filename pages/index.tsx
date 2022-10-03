import React from 'react';
import Image from 'next/image';
import { ConnectButton } from '@rainbow-me/rainbowkit';
import type { NextPage } from 'next';
import {
  useAccount,
  useContractRead,
  useContractWrite,
  usePrepareContractWrite,
  useWaitForTransaction,
} from 'wagmi';
import contractInterface from '../contract-abi.json';
import FlipCard, { BackCard, FrontCard } from '../components/FlipCard';


const contractConfig = {
  addressOrName: '0xFBA2B65F57EFD96a313ACBAD18Ff5625336AF18E',
  contractInterface: contractInterface,
};

const Home: NextPage = () => {
  const [mounted, setMounted] = React.useState(false);
  const [text, setText] = React.useState("Write Custom Text");
  React.useEffect(() => setMounted(true), []);


  const [totalMinted, setTotalMinted] = React.useState(0);
  const { isConnected } = useAccount();

  const { config: contractWriteConfig } = usePrepareContractWrite({
    ...contractConfig,
    functionName: 'mintText',
    args: [text],
    enabled: Boolean(text)
  });

  const {
    data: mintData,
    write: mint,
    isLoading: isMintLoading,
    isSuccess: isMintStarted,
    error: mintError,
  } = useContractWrite(contractWriteConfig);

  const { data: totalSupplyData } = useContractRead({
    ...contractConfig,
    functionName: 'totalSupply',
    watch: true,
  });

  const {
    data: txData,
    isSuccess: txSuccess,
    error: txError,
  } = useWaitForTransaction({
    hash: mintData?.hash,
  });

  React.useEffect(() => {
    if (totalSupplyData) {
      setTotalMinted(totalSupplyData.toNumber());
    }
  }, [totalSupplyData]);

  const isMinted = txSuccess;

  return (
    <div className="page">
      <div className="container">
        <div style={{ flex: '1 1 auto' }}>
          <div style={{ padding: '24px 24px 24px 0' }}>
            <h1>SVG CUSTOM TEXT NFT MINT</h1>
            <p style={{ margin: '12px 0 24px' }}>
              {totalMinted} minted so far!
            </p>
            <ConnectButton />

            {mintError && (
              <p style={{ marginTop: 24, color: '#FF6257' }}>
                Error: {mintError.message}
              </p>
            )}
            {txError && (
              <p style={{ marginTop: 24, color: '#FF6257' }}>
                Error: {txError.message}
              </p>
            )}
           
            
            {mounted && isConnected && (
<>
<div className='text'>
<label> Message</label>
<input type='text'  value={text} onChange={(e)=>setText(e.target.value)}/>
</div>
              <button
                style={{ marginTop: 24 }}
                disabled={!mint || isMintLoading || isMintStarted || text===""}
                className="button"
                data-mint-loading={isMintLoading}
                data-mint-started={isMintStarted}
                onClick={() => mint?.()}
              >
                {isMintLoading && 'Waiting for approval'}
                {isMintStarted && 'Minting...'}
                {!isMintLoading && !isMintStarted && 'Mint'}
              </button>
              </>
            )}
          </div>
        </div>

        <div style={{ flex: '0 0 auto' }}>
          <FlipCard>
          
            <FrontCard isCardFlipped={isMinted}>

{mounted && isConnected ? ( <svg width="350"
                height="250" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 350 250"><style>@import url(https://fonts.googleapis.com/css2?family=Monoton);@import url(https://fonts.googleapis.com/css?family=Anonymous+Pro:400,400i,700,700i);</style><rect className="rect" width="100%" height="500%" fill="#fff"/><text x="50%" y="50%" dominantBaseline="middle" textAnchor="middle" fontFamily="Cursive" fontWeight="800" fontSize="18" fill="red">{text} </text></svg>): ( <Image
                layout="responsive"
                src="/mintText.png"
                width="500"
                height="500"
                alt="SVG Demo NFT"
              />
             )}

           
             
            </FrontCard>
            <BackCard isCardFlipped={isMinted}>
              <div style={{ padding: 24 }}>
                <Image
                  src="/nft.png"
                  width="80"
                  height="80"
                  alt="SVG Demo NFT"
                  style={{ borderRadius: 8 }}
                />
                <h2 style={{ marginTop: 24, marginBottom: 6 }}>NFT Minted!</h2>
                <p style={{ marginBottom: 24 }}>
                  Your NFT will show up in your wallet in the next few minutes.
                </p>
                <p style={{ marginBottom: 6 }}>
                  View on{' '}
                  <a href={`https://goerli.etherscan.io/tx/${mintData?.hash}`}>
                    Etherscan
                  </a>
                </p>
                <p>
                  View on{' '}
                  <a
                    href={`https://testnets.opensea.io/assets/goerli/${txData?.to}/1`}
                  >
                    Opensea
                  </a>
                </p>
              </div>
            </BackCard>
          </FlipCard>
        </div>
        
      <footer> Created by Taofeek <a
                    href={`https://twitter.com/taofeek_ob`}
                 target='blank' >Twitter</a> & <a
                  href={`https://github.com/taofeek-ob`}
                  target='blank' >Github</a></footer>
      </div>

    </div>
  );
};

export default Home;
